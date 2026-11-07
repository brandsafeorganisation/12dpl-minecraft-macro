// Cubeland desktop host for Windows
//
// The macro is translated to C++ by tools/test_harness/translate.py and
// compiled with this file. Here the 12d library calls it needs for panels,
// widgets, the Draw_Box and events are implemented with plain Win32:
//
//   panels      top-level windows; their widgets (Append order) are laid
//               out top to bottom, button groups left to right
//   widgets     message boxes -> static text, input boxes -> edit boxes,
//               file boxes -> edit + Browse, list boxes -> list boxes,
//               buttons -> buttons
//   Draw_Box    a child window showing a 32 bit bitmap; polygons are filled
//               by a small rasteriser, text is drawn with GDI
//   events      Wait_on_events turns window messages into the 12d event
//               names the macro expects (mouse_move, click_lb_down,
//               click_lb, click_rb, keystroke, Panel Quit, Panel_Resize,
//               kill_focus and button replies). When nothing happens a
//               mouse_move is made up every few milliseconds, which keeps
//               the game's frames coming like 12d's cursor warps do.
//
// Only the panel/widget/drawing/event/time calls live here; everything
// else (maths, text, files, Attributes) is in ../test_harness/runtime.h.

#define CUBELAND_DESKTOP 1
#include "runtime.h"
#define NOMINMAX
#include <windows.h>
#include <commdlg.h>
#include <deque>
#include <chrono>
#include <ctime>

// ---------------------------------------------------------------- globals the runtime expects
double g_sim_time = 0.0;
long long g_next_id = 0;
long long g_attribute_calls = 0;
long long g_attribute_type_errors = 0;
std::map<Text,long long> g_attribute_by_name;

extern void macro_main();

// ---------------------------------------------------------------- widget table
enum Kind { K_PANEL = 1, K_VGROUP, K_HGROUP, K_MESSAGE, K_INPUT, K_FILE, K_LIST, K_BUTTON, K_DRAW };

struct Node {
  long long id = 0;
  int kind = 0;
  Text title;                 // label / caption
  Text reply;                 // button reply
  long long parent = 0;
  std::vector<long long> kids;
  HWND hwnd = 0;              // the control (or panel window)
  HWND label = 0;             // input / file box label
  HWND browse = 0;            // file box Browse button
  Text value;                 // message / input text
  std::vector<Text> items;    // list box
  int sel = 0;                // list box selection, 1-based
  int want_w = 0, want_h = 0; // draw box size asked for
  bool keys = false;          // the game's key box (shown as a hint)
};
static std::map<long long, Node> g_nodes;
static std::map<int, long long> g_ctrl_to_id;   // control id -> widget id
static int g_next_ctrl = 1000;

struct Event { long long id; Text cmd, msg; };
static std::deque<Event> g_events;

static HINSTANCE g_inst = 0;
static HFONT g_ui_font = 0;
static double g_last_warp = -10.0;
static double g_last_tick = 0.0;

static double now_seconds() {
  using namespace std::chrono;
  return duration_cast<duration<double>>(system_clock::now().time_since_epoch()).count();
}
int Get_time(double &t) { t = now_seconds(); return 0; }
int Get_time(int &t) { t = (int)time(nullptr); return 0; }

static Node &node(long long id) { return g_nodes[id]; }
static long long new_node(int kind, const Text &title) {
  long long id = ++g_next_id;
  Node &n = g_nodes[id];
  n.id = id; n.kind = kind; n.title = title;
  return id;
}
template <class T> static T as(long long id) { T w; w.id = id; w.title = g_nodes[id].title; w.kind = g_nodes[id].kind; return w; }

static long long panel_of(long long id) {
  while (id && g_nodes[id].kind != K_PANEL) id = g_nodes[id].parent;
  return id;
}
static long long find_kind(long long root, int kind) {
  Node &n = g_nodes[root];
  if (n.kind == kind) return root;
  for (long long k : n.kids) { long long f = find_kind(k, kind); if (f) return f; }
  return 0;
}
static long long key_box_of(long long panel) {
  std::vector<long long> stack{panel};
  while (!stack.empty()) {
    long long id = stack.back(); stack.pop_back();
    if (g_nodes[id].keys) return id;
    for (long long k : g_nodes[id].kids) stack.push_back(k);
  }
  return 0;
}
static FILE *g_log = nullptr;   // set CUBELAND_LOG=1 to write cubeland_log.txt
static void log_line(const char *what, long long id, const Text &a, const Text &b) {
  if (!g_log) return;
  fprintf(g_log, "%.3f %s %lld %s %s\n", fmod(now_seconds(), 1000.0), what, id, a.c_str(), b.c_str());
  fflush(g_log);
}
static void push_event(long long id, const Text &cmd, const Text &msg) { g_events.push_back({id, cmd, msg}); }

// ---------------------------------------------------------------- creating widgets
Panel Create_panel(const Text &t) { return as<Panel>(new_node(K_PANEL, t)); }
Panel Create_panel(const Text &t, int) { return as<Panel>(new_node(K_PANEL, t)); }
Vertical_Group Create_vertical_group(int) { return as<Vertical_Group>(new_node(K_VGROUP, "")); }
Horizontal_Group Create_button_group() { return as<Horizontal_Group>(new_node(K_HGROUP, "")); }
Colour_Message_Box Create_colour_message_box(const Text &t) { long long id = new_node(K_MESSAGE, ""); g_nodes[id].value = t; return as<Colour_Message_Box>(id); }
Input_Box Create_input_box(const Text &t, const Message_Box &) {
  long long id = new_node(K_INPUT, t);
  if (t.compare(0, 4, "Keys") == 0) g_nodes[id].keys = true;
  return as<Input_Box>(id);
}
File_Box Create_file_box(const Text &t, const Message_Box &, int, const Text &) { return as<File_Box>(new_node(K_FILE, t)); }
List_Box Create_list_box(const Text &t, const Message_Box &, int) { return as<List_Box>(new_node(K_LIST, t)); }
Button Create_button(const Text &t, const Text &r) { long long id = new_node(K_BUTTON, t); g_nodes[id].reply = r; return as<Button>(id); }
Button Create_finish_button(const Text &t, const Text &r) { return Create_button(t, r); }
Draw_Box Create_draw_box(int w, int h, int) {
  long long id = new_node(K_DRAW, "");
  g_nodes[id].want_w = w; g_nodes[id].want_h = h;
  Draw_Box d = as<Draw_Box>(id); d.w = w; d.h = h; return d;
}
int Append(const Widget &child, const Widget &parent) {
  g_nodes[parent.id].kids.push_back(child.id);
  g_nodes[child.id].parent = parent.id;
  return 0;
}
int Set_sizing_constraints(const Widget &, int, int) { return 0; }
int Set_notify_resizing(const Widget &) { return 0; }

// ---------------------------------------------------------------- data
static Text window_text(HWND h) {
  int n = GetWindowTextLengthA(h);
  Text t(n, '\0');
  if (n > 0) GetWindowTextA(h, &t[0], n + 1);
  return t;
}
int Set_data(const Colour_Message_Box &b, const Text &t) { Node &n = node(b.id); n.value = t; if (n.hwnd) SetWindowTextA(n.hwnd, t.c_str()); return 0; }
static int set_text(long long id, const Text &t) { Node &n = node(id); n.value = t; if (n.hwnd && !n.keys) SetWindowTextA(n.hwnd, t.c_str()); return 0; }
static int get_text(long long id, Text &t) { Node &n = node(id); if (n.hwnd && !n.keys) n.value = window_text(n.hwnd); t = n.value; return 0; }
int Set_data(const Input_Box &b, const Text &t) { return set_text(b.id, t); }
int Get_data(const Input_Box &b, Text &t) { return get_text(b.id, t); }
int Set_data(const File_Box &b, const Text &t) { return set_text(b.id, t); }
int Get_data(const File_Box &b, Text &t) { return get_text(b.id, t); }

int Get_number_of_items(const List_Box &b, int &n) { n = (int)node(b.id).items.size(); return 0; }
int Delete_item(const List_Box &b, int p) {
  Node &n = node(b.id);
  if (p < 1 || p > (int)n.items.size()) return 1;
  n.items.erase(n.items.begin() + (p - 1));
  if (n.hwnd) SendMessageA(n.hwnd, LB_DELETESTRING, p - 1, 0);
  return 0;
}
int Add_item(const List_Box &b, const Text &t) {
  Node &n = node(b.id);
  n.items.push_back(t);
  if (n.hwnd) SendMessageA(n.hwnd, LB_ADDSTRING, 0, (LPARAM)t.c_str());
  return 0;
}
int Set_selection(const List_Box &b, int p) { Node &n = node(b.id); n.sel = p; if (n.hwnd) SendMessageA(n.hwnd, LB_SETCURSEL, p - 1, 0); return 0; }
int Get_selection(const List_Box &b, int &p) {
  Node &n = node(b.id);
  if (n.hwnd) { LRESULT r = SendMessageA(n.hwnd, LB_GETCURSEL, 0, 0); n.sel = (r == LB_ERR) ? 0 : (int)r + 1; }
  p = n.sel; return 0;
}
int Get_item(const List_Box &b, int p, Text &t) { Node &n = node(b.id); if (p < 1 || p > (int)n.items.size()) return 1; t = n.items[p - 1]; return 0; }

// ---------------------------------------------------------------- layout
static const int PAD = 8, ROW = 24, GAP = 6, LABEL_W = 250, LIST_H = 150;

static int fixed_height(long long id) {
  Node &n = g_nodes[id];
  switch (n.kind) {
    case K_PANEL: case K_VGROUP: { int h = 0; for (long long k : n.kids) h += fixed_height(k) + (n.kind == K_VGROUP ? GAP : 0); return h; }
    case K_HGROUP: return ROW + 4;
    case K_MESSAGE: return 20;
    case K_INPUT: case K_FILE: return n.keys ? 18 : ROW;
    case K_LIST: return LIST_H + 20;
    case K_BUTTON: return ROW + 4;
    case K_DRAW: return 0;   // takes what is left
  }
  return 0;
}
static int text_width(const Text &t) {
  HDC dc = GetDC(0);
  HGDIOBJ old = SelectObject(dc, g_ui_font);
  SIZE s{0, 0};
  GetTextExtentPoint32A(dc, t.c_str(), (int)t.size(), &s);
  SelectObject(dc, old);
  ReleaseDC(0, dc);
  return s.cx;
}
static void place(long long id, int x, int y, int w, int h);
static void place_vertical(Node &n, int x, int y, int w, int h) {
  int fixed = 0, draws = 0;
  for (long long k : n.kids) { fixed += fixed_height(k) + GAP; if (find_kind(k, K_DRAW)) ++draws; }
  int spare = h - fixed; if (spare < 60) spare = 60;
  for (long long k : n.kids) {
    int kh = fixed_height(k);
    if (find_kind(k, K_DRAW)) kh += spare / (draws ? draws : 1);
    place(k, x, y, w, kh);
    y += kh + GAP;
  }
}
static void place(long long id, int x, int y, int w, int h) {
  Node &n = g_nodes[id];
  switch (n.kind) {
    case K_PANEL: case K_VGROUP: place_vertical(n, x, y, w, h); break;
    case K_HGROUP: {
      int bx = x;
      for (long long k : n.kids) {
        Node &b = g_nodes[k];
        int bw = text_width(b.title) + 28; if (bw < 70) bw = 70;
        if (bx + bw > x + w && bx > x) { bx = x; }   // too wide: start over (rare)
        if (b.hwnd) MoveWindow(b.hwnd, bx, y, bw, ROW + 2, TRUE);
        bx += bw + 4;
      }
      break;
    }
    case K_MESSAGE: case K_BUTTON: case K_DRAW:
      if (n.hwnd) MoveWindow(n.hwnd, x, y, w, h, TRUE);
      break;
    case K_LIST:
      if (n.label) MoveWindow(n.label, x, y, w, 18, TRUE);
      if (n.hwnd) MoveWindow(n.hwnd, x, y + 20, w, h - 20, TRUE);
      break;
    case K_INPUT: case K_FILE:
      if (n.keys) { if (n.hwnd) MoveWindow(n.hwnd, x, y, w, h, TRUE); break; }
      if (n.label) MoveWindow(n.label, x, y + 4, LABEL_W, h - 4, TRUE);
      if (n.kind == K_FILE) {
        if (n.hwnd) MoveWindow(n.hwnd, x + LABEL_W, y, w - LABEL_W - 84, h, TRUE);
        if (n.browse) MoveWindow(n.browse, x + w - 80, y, 80, h, TRUE);
      } else if (n.hwnd) {
        MoveWindow(n.hwnd, x + LABEL_W, y, w - LABEL_W, h, TRUE);
      }
      break;
  }
}
static void layout_panel(long long panel) {
  Node &p = g_nodes[panel];
  if (!p.hwnd) return;
  RECT r; GetClientRect(p.hwnd, &r);
  place(panel, PAD, PAD, r.right - 2 * PAD, r.bottom - 2 * PAD);
}

// ---------------------------------------------------------------- the view (Draw_Box)
static HDC g_mdc = 0;
static HBITMAP g_dib = 0;
static unsigned *g_bits = nullptr;
static int g_fb_w = 0, g_fb_h = 0;
static HWND g_drawing_hwnd = 0;

static void ensure_framebuffer(int w, int h) {
  if (w < 1) w = 1; if (h < 1) h = 1;
  if (g_dib && w == g_fb_w && h == g_fb_h) return;
  if (!g_mdc) { HDC dc = GetDC(0); g_mdc = CreateCompatibleDC(dc); ReleaseDC(0, dc); }
  if (g_dib) DeleteObject(g_dib);
  BITMAPINFO bi; ZeroMemory(&bi, sizeof bi);
  bi.bmiHeader.biSize = sizeof bi.bmiHeader;
  bi.bmiHeader.biWidth = w; bi.bmiHeader.biHeight = -h;   // top-down
  bi.bmiHeader.biPlanes = 1; bi.bmiHeader.biBitCount = 32; bi.bmiHeader.biCompression = BI_RGB;
  void *bits = nullptr;
  g_dib = CreateDIBSection(g_mdc, &bi, DIB_RGB_COLORS, &bits, 0, 0);
  SelectObject(g_mdc, g_dib);
  g_bits = (unsigned *)bits; g_fb_w = w; g_fb_h = h;
  SetBkMode(g_mdc, TRANSPARENT);
}
static void present(HWND hwnd) {
  if (!hwnd || !g_dib) return;
  GdiFlush();
  HDC dc = GetDC(hwnd);
  BitBlt(dc, 0, 0, g_fb_w, g_fb_h, g_mdc, 0, 0, SRCCOPY);
  ReleaseDC(hwnd, dc);
}

static bool cursor_hidden() { return now_seconds() - g_last_warp < 0.4; }

static long long view_id(HWND h) { return (long long)GetWindowLongPtrA(h, GWLP_USERDATA); }
static Text box_xy(HWND h, int cx, int cy) {
  RECT r; GetClientRect(h, &r);
  char b[64]; snprintf(b, sizeof b, "%d %d", cx, (int)(r.bottom - cy));
  return b;
}
static LRESULT CALLBACK view_proc(HWND h, UINT m, WPARAM w, LPARAM l) {
  long long id = view_id(h);
  switch (m) {
    case WM_PAINT: { PAINTSTRUCT ps; BeginPaint(h, &ps); EndPaint(h, &ps); present(h); return 0; }
    case WM_ERASEBKGND: return 1;
    case WM_SETCURSOR: if (LOWORD(l) == HTCLIENT && cursor_hidden()) { SetCursor(0); return TRUE; } break;
    case WM_MOUSEMOVE: push_event(id, "mouse_move", box_xy(h, (short)LOWORD(l), (short)HIWORD(l))); return 0;
    case WM_LBUTTONDOWN: SetFocus(h); push_event(id, "click_lb_down", box_xy(h, (short)LOWORD(l), (short)HIWORD(l))); return 0;
    case WM_LBUTTONUP: push_event(id, "click_lb", box_xy(h, (short)LOWORD(l), (short)HIWORD(l))); return 0;
    case WM_RBUTTONDOWN: SetFocus(h); return 0;
    case WM_RBUTTONUP: push_event(id, "click_rb", box_xy(h, (short)LOWORD(l), (short)HIWORD(l))); return 0;
    case WM_CHAR: {
      long long keys = key_box_of(panel_of(id));
      if (w >= 32 && w < 127) { char c[2] = {(char)w, 0}; push_event(keys, "keystroke", c); }
      return 0;
    }
    case WM_KEYDOWN:
      if (w == VK_ESCAPE) push_event(key_box_of(panel_of(id)), "keystroke", "q");
      // Shift alone types nothing; held down it repeats, which the
      // game reads as crouching (or sinking while flying)
      if (w == VK_SHIFT) push_event(key_box_of(panel_of(id)), "keystroke", "shift");
      return 0;
    case WM_GETDLGCODE: return DLGC_WANTALLKEYS | DLGC_WANTCHARS;
  }
  return DefWindowProcA(h, m, w, l);
}

int Get_size(const Draw_Box &b, int &w, int &h) {
  Node &n = node(b.id);
  if (n.hwnd) { RECT r; GetClientRect(n.hwnd, &r); w = r.right; h = r.bottom; }
  else { w = n.want_w; h = n.want_h; }
  if (w < 1) w = 1; if (h < 1) h = 1;
  return 0;
}
int Get_position(const Widget &wd, int &x, int &y) {
  Node &n = node(wd.id);
  if (n.hwnd) { POINT p{0, 0}; ClientToScreen(n.hwnd, &p); x = p.x; y = p.y; }
  else { x = 0; y = 0; }
  return 0;
}
int Get_cursor_position(int &x, int &y) { POINT p; GetCursorPos(&p); x = p.x; y = p.y; return 0; }
int Set_cursor_position(int x, int y) { g_last_warp = now_seconds(); SetCursorPos(x, y); SetCursor(0); return 0; }

// ---------------------------------------------------------------- drawing
static unsigned g_pen = 0, g_fill = 0, g_text = 0xffffff;
static int g_align = 0;
static double g_pen_x = 0, g_pen_y = 0;
static bool g_gdi_dirty = false;
static std::map<std::pair<std::string, int>, HFONT> g_fonts;
static std::string g_font_name = "Segoe UI";   // Set_text_font; Segoe UI stands in for 12d's default

static unsigned rgb(int r, int g, int b) {
  if (r < 0) r = 0; if (r > 255) r = 255; if (g < 0) g = 0; if (g > 255) g = 255; if (b < 0) b = 0; if (b > 255) b = 255;
  return ((unsigned)r << 16) | ((unsigned)g << 8) | (unsigned)b;
}
static inline void put(int x, int y, unsigned c) {
  if (x < 0 || y < 0 || x >= g_fb_w || y >= g_fb_h) return;
  g_bits[(g_fb_h - 1 - y) * g_fb_w + x] = c;
}
int Start_batch_draw(const Draw_Box &b) {
  int w, h; Get_size(b, w, h);
  ensure_framebuffer(w, h);
  g_drawing_hwnd = node(b.id).hwnd;
  return 0;
}
int End_batch_draw(const Draw_Box &) { present(g_drawing_hwnd); return 0; }
int Set_colour(const Draw_Box &, int r, int g, int b) { g_pen = rgb(r, g, b); return 0; }
int Set_fill_colour(const Draw_Box &, int r, int g, int b) { g_fill = rgb(r, g, b); return 0; }
int Draw_polygon(const Draw_Box &, int n, double *x, double *y) {
  if (!g_bits || n < 3) return 1;
  if (g_gdi_dirty) { GdiFlush(); g_gdi_dirty = false; }
  static std::vector<double> xs;
  double ymin = 1e18, ymax = -1e18;
  for (int i = 1; i <= n; i++) { if (!std::isfinite(x[i]) || !std::isfinite(y[i])) return 1; ymin = std::min(ymin, y[i]); ymax = std::max(ymax, y[i]); }
  int y0 = std::max(0, (int)std::floor(ymin)), y1 = std::min(g_fb_h - 1, (int)std::ceil(ymax));
  for (int py = y0; py <= y1; py++) {
    double sy = py + 0.5; xs.clear();
    for (int i = 1; i <= n; i++) {
      int j = i % n + 1; double ay = y[i], by = y[j];
      if ((ay <= sy && by > sy) || (by <= sy && ay > sy)) xs.push_back(x[i] + (sy - ay) * (x[j] - x[i]) / (by - ay));
    }
    std::sort(xs.begin(), xs.end());
    unsigned *row = g_bits + (g_fb_h - 1 - py) * g_fb_w;
    for (size_t k = 0; k + 1 < xs.size(); k += 2) {
      int xa = std::max(0, (int)std::ceil(xs[k] - 0.5)), xb = std::min(g_fb_w - 1, (int)std::floor(xs[k + 1] - 0.5));
      for (int px = xa; px <= xb; px++) row[px] = g_fill;
    }
  }
  return 0;
}
int Move_to(const Draw_Box &, double x, double y) { g_pen_x = x; g_pen_y = y; return 0; }
int Draw_to(const Draw_Box &, double x, double y) {
  if (!g_bits) return 1;
  if (g_gdi_dirty) { GdiFlush(); g_gdi_dirty = false; }
  double dx = x - g_pen_x, dy = y - g_pen_y;
  int n = (int)std::max(std::fabs(dx), std::fabs(dy)) + 1; if (n > 5000) n = 5000;
  for (int i = 0; i <= n; i++) put((int)(g_pen_x + dx * i / n), (int)(g_pen_y + dy * i / n), g_pen);
  g_pen_x = x; g_pen_y = y; return 0;
}
int Set_text_align(const Draw_Box &, int a) { g_align = a; return 0; }
int Set_text_colour(const Draw_Box &, int r, int g, int b) { g_text = rgb(r, g, b); return 0; }
int Set_text_font(const Draw_Box &, const Text &font) { g_font_name = font.empty() ? "Segoe UI" : font; return 0; }
int Draw_text(const Draw_Box &, double x, double y, double size, double, const Text &t) {
  if (!g_mdc) return 1;
  int px = (int)(size + 0.5); if (px < 6) px = 6;
  HFONT &f = g_fonts[std::make_pair(g_font_name, px)];
  if (!f) f = CreateFontA(-px, 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                          ANTIALIASED_QUALITY, DEFAULT_PITCH | FF_SWISS, g_font_name.c_str());
  SelectObject(g_mdc, f);
  SetTextColor(g_mdc, RGB((g_text >> 16) & 255, (g_text >> 8) & 255, g_text & 255));
  SetTextAlign(g_mdc, (g_align == 30 ? TA_CENTER : TA_LEFT) | TA_TOP);
  TextOutA(g_mdc, (int)x, g_fb_h - (int)y, t.c_str(), (int)t.size());
  g_gdi_dirty = true;
  return 0;
}

// ---------------------------------------------------------------- panels
static LRESULT CALLBACK panel_proc(HWND h, UINT m, WPARAM w, LPARAM l) {
  long long id = (long long)GetWindowLongPtrA(h, GWLP_USERDATA);
  switch (m) {
    case WM_CLOSE: push_event(id, "Panel Quit", ""); return 0;
    case WM_SIZE: if (id) { layout_panel(id); push_event(id, "Panel_Resize", ""); } return 0;
    case WM_ACTIVATE:
      if (LOWORD(w) == WA_INACTIVE && id) { long long k = key_box_of(id); if (k) push_event(k, "kill_focus", ""); }
      break;
    case WM_GETMINMAXINFO: { MINMAXINFO *mm = (MINMAXINFO *)l; mm->ptMinTrackSize.x = 480; mm->ptMinTrackSize.y = 240; return 0; }
    case WM_COMMAND: {
      int ctrl = LOWORD(w), code = HIWORD(w);
      auto it = g_ctrl_to_id.find(ctrl);
      if (it == g_ctrl_to_id.end()) break;
      Node &n = g_nodes[it->second];
      if (n.kind == K_BUTTON && code == BN_CLICKED) {
        push_event(n.id, n.reply, "");
        long long view = find_kind(panel_of(n.id), K_DRAW);
        if (view && g_nodes[view].hwnd) SetFocus(g_nodes[view].hwnd);
      } else if (n.kind == K_FILE && (HWND)l == n.browse && code == BN_CLICKED) {
        char file[MAX_PATH] = "";
        OPENFILENAMEA of; ZeroMemory(&of, sizeof of);
        of.lStructSize = sizeof of; of.hwndOwner = h; of.lpstrFile = file; of.nMaxFile = MAX_PATH;
        of.lpstrFilter = "Resource packs (*.zip)\0*.zip\0All files\0*.*\0";
        of.Flags = OFN_FILEMUSTEXIST | OFN_NOCHANGEDIR;
        if (GetOpenFileNameA(&of)) set_text(n.id, file);
      } else if ((n.kind == K_INPUT || n.kind == K_FILE) && code == EN_CHANGE) {
        n.value = window_text(n.hwnd);
      }
      return 0;
    }
  }
  return DefWindowProcA(h, m, w, l);
}

static void create_controls(long long id, HWND parent) {
  Node &n = g_nodes[id];
  auto ctrl = [&](const char *cls, const char *text, DWORD style, DWORD ex = 0) {
    int cid = g_next_ctrl++;
    g_ctrl_to_id[cid] = id;
    HWND hw = CreateWindowExA(ex, cls, text, WS_CHILD | WS_VISIBLE | style, 0, 0, 10, 10, parent, (HMENU)(INT_PTR)cid, g_inst, 0);
    SendMessageA(hw, WM_SETFONT, (WPARAM)g_ui_font, TRUE);
    return hw;
  };
  switch (n.kind) {
    case K_MESSAGE: n.hwnd = ctrl("STATIC", n.value.c_str(), SS_LEFT | SS_ENDELLIPSIS | SS_NOPREFIX); break;
    case K_BUTTON: n.hwnd = ctrl("BUTTON", n.title.c_str(), BS_PUSHBUTTON | WS_TABSTOP); break;
    case K_INPUT: case K_FILE:
      if (n.keys) { n.hwnd = ctrl("STATIC", "Keys go to the game view (click the view if they stop working). Esc pauses.", SS_LEFT | SS_NOPREFIX); break; }
      n.label = ctrl("STATIC", n.title.c_str(), SS_LEFT | SS_NOPREFIX);
      n.hwnd = ctrl("EDIT", n.value.c_str(), ES_AUTOHSCROLL | WS_TABSTOP, WS_EX_CLIENTEDGE);
      if (n.kind == K_FILE) n.browse = ctrl("BUTTON", "Browse...", BS_PUSHBUTTON);
      break;
    case K_LIST:
      n.label = ctrl("STATIC", n.title.c_str(), SS_LEFT | SS_NOPREFIX);
      n.hwnd = ctrl("LISTBOX", "", LBS_NOTIFY | WS_VSCROLL | WS_TABSTOP | LBS_NOINTEGRALHEIGHT, WS_EX_CLIENTEDGE);
      for (auto &t : n.items) SendMessageA(n.hwnd, LB_ADDSTRING, 0, (LPARAM)t.c_str());
      if (n.sel > 0) SendMessageA(n.hwnd, LB_SETCURSEL, n.sel - 1, 0);
      break;
    case K_DRAW:
      n.hwnd = CreateWindowExA(0, "CubelandView", "", WS_CHILD | WS_VISIBLE | WS_TABSTOP, 0, 0, n.want_w, n.want_h, parent, 0, g_inst, 0);
      SetWindowLongPtrA(n.hwnd, GWLP_USERDATA, (LONG_PTR)id);
      break;
  }
  for (long long k : n.kids) create_controls(k, parent);
}
static void forget_controls(long long id) {
  Node &n = g_nodes[id];
  n.hwnd = 0; n.label = 0; n.browse = 0;
  for (long long k : n.kids) forget_controls(k);
}

int Show_widget(const Widget &wd) {
  Node &p = g_nodes[wd.id];
  if (p.kind != K_PANEL) return 0;
  log_line("show", wd.id, p.title, "");
  if (p.hwnd) { ShowWindow(p.hwnd, SW_SHOW); return 0; }

  long long view = find_kind(wd.id, K_DRAW);
  int cw = 600, ch = fixed_height(wd.id) + 2 * PAD;
  if (view) {
    cw = std::max(cw, g_nodes[view].want_w + 2 * PAD);
    ch += g_nodes[view].want_h;
  }
  RECT r{0, 0, cw, ch};
  DWORD style = WS_OVERLAPPEDWINDOW;
  AdjustWindowRect(&r, style, FALSE);
  int ww = r.right - r.left, wh = r.bottom - r.top;
  int sx = (GetSystemMetrics(SM_CXSCREEN) - ww) / 2, sy = (GetSystemMetrics(SM_CYSCREEN) - wh) / 2;
  if (sy < 0) sy = 0;
  p.hwnd = CreateWindowExA(0, "CubelandPanel", p.title.c_str(), style, sx, sy, ww, wh, 0, 0, g_inst, 0);
  SetWindowLongPtrA(p.hwnd, GWLP_USERDATA, (LONG_PTR)wd.id);
  for (long long k : p.kids) create_controls(k, p.hwnd);
  layout_panel(wd.id);
  ShowWindow(p.hwnd, SW_SHOW);
  UpdateWindow(p.hwnd);
  SetForegroundWindow(p.hwnd);
  if (view) SetFocus(g_nodes[view].hwnd);
  return 0;
}
int Hide_widget(const Widget &wd) {
  Node &p = g_nodes[wd.id];
  if (p.kind != K_PANEL || !p.hwnd) return 0;
  HWND h = p.hwnd;
  forget_controls(wd.id);
  if (g_drawing_hwnd && !IsWindow(g_drawing_hwnd)) g_drawing_hwnd = 0;
  DestroyWindow(h);
  g_drawing_hwnd = 0;
  // drop events that belonged to it
  std::deque<Event> keep;
  for (auto &e : g_events) if (panel_of(e.id) != wd.id) keep.push_back(e);
  g_events.swap(keep);
  return 0;
}
int Set_focus(const Widget &wd) {
  Node &n = g_nodes[wd.id];
  if (n.keys) { long long view = find_kind(panel_of(wd.id), K_DRAW); if (view && g_nodes[view].hwnd) SetFocus(g_nodes[view].hwnd); }
  else if (n.hwnd) SetFocus(n.hwnd);
  return 0;
}

// ---------------------------------------------------------------- events
static HWND visible_view() {
  // the view of the panel in front; none if that panel has no view
  // (another panel, such as the settings, is open over the game)
  HWND fg = GetForegroundWindow();
  for (auto &kv : g_nodes) {
    Node &n = kv.second;
    if (n.kind != K_DRAW || !n.hwnd || !IsWindowVisible(n.hwnd)) continue;
    if (GetAncestor(n.hwnd, GA_ROOT) == fg) return n.hwnd;
  }
  return 0;
}

int Wait_on_events(long long &id, Text &cmd, Text &msg) {
  MSG m;
  while (true) {
    MsgWaitForMultipleObjects(0, nullptr, FALSE, 0, QS_ALLINPUT);   // lets pending painting through
    while (PeekMessageA(&m, 0, 0, 0, PM_REMOVE)) {
      if (m.message == WM_QUIT) { id = 0; cmd = "CodeShutdown"; msg = ""; return 0; }
      TranslateMessage(&m);
      DispatchMessageA(&m);
    }
    if (!g_events.empty()) {
      Event e = g_events.front(); g_events.pop_front();
      // successive mouse moves: only the newest matters
      while (e.cmd == "mouse_move" && !g_events.empty() && g_events.front().cmd == "mouse_move" && g_events.front().id == e.id) {
        e = g_events.front(); g_events.pop_front();
      }
      id = e.id; cmd = e.cmd; msg = e.msg;
      if (cmd != "mouse_move") log_line("event", id, cmd, msg);
      return 0;
    }
    // Nothing happened: a made-up mouse move keeps a game view ticking
    HWND view = visible_view();
    double t = now_seconds();
    if (view && t - g_last_tick > 0.004) {
      g_last_tick = t;
      POINT p; GetCursorPos(&p); ScreenToClient(view, &p);
      id = view_id(view); cmd = "mouse_move"; msg = box_xy(view, p.x, p.y);
      return 0;
    }
    MsgWaitForMultipleObjects(0, nullptr, FALSE, view ? 2 : 50, QS_ALLINPUT);
  }
}

// ---------------------------------------------------------------- start
int main() {
  g_inst = GetModuleHandleA(0);
  // Work in the program's own folder, so the worlds and settings are
  // kept next to it however it was started
  char exe[MAX_PATH];
  if (GetModuleFileNameA(0, exe, MAX_PATH)) {
    char *slash = strrchr(exe, '\\');
    if (slash) { *slash = 0; SetCurrentDirectoryA(exe); }
  }
  if (getenv("CUBELAND_LOG")) g_log = fopen("cubeland_log.txt", "w");
  SetProcessDPIAware();
  NONCLIENTMETRICSA ncm; ncm.cbSize = sizeof ncm;
  if (SystemParametersInfoA(SPI_GETNONCLIENTMETRICS, sizeof ncm, &ncm, 0)) g_ui_font = CreateFontIndirectA(&ncm.lfMessageFont);
  if (!g_ui_font) g_ui_font = (HFONT)GetStockObject(DEFAULT_GUI_FONT);

  WNDCLASSA wc; ZeroMemory(&wc, sizeof wc);
  wc.lpfnWndProc = panel_proc; wc.hInstance = g_inst; wc.lpszClassName = "CubelandPanel";
  wc.hCursor = LoadCursor(0, IDC_ARROW); wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1);
  wc.hIcon = LoadIcon(0, IDI_APPLICATION);
  RegisterClassA(&wc);
  WNDCLASSA vc; ZeroMemory(&vc, sizeof vc);
  vc.lpfnWndProc = view_proc; vc.hInstance = g_inst; vc.lpszClassName = "CubelandView";
  vc.hCursor = LoadCursor(0, IDC_CROSS);
  RegisterClassA(&vc);

  macro_main();
  return 0;
}
