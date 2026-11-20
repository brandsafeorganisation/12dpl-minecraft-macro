// Test driver: rasteriser for Draw_Box calls and a scripted event source
#include "runtime.h"
#include <sstream>
#include <deque>
double g_sim_time = 13300000000.0;
Text g_opened_file;
long long g_next_id = 0;
long long g_attribute_calls = 0;
long long g_attribute_type_errors = 0;
std::map<Text,long long> g_attribute_by_name;
std::map<Text,long long> g_widget_by_title;
std::map<long long,Text> g_input_value;
std::map<long long,std::vector<Text>> g_list_items;
std::map<long long,int> g_list_sel;
Text g_last_message;
int g_box_w=0, g_box_h=0;
int g_cursor_x=0, g_cursor_y=0;

// ---------------------------------------------------------------- raster
static std::vector<unsigned char> fb;
static int pen[3]={0,0,0}, fill[3]={0,0,0}, txtc[3]={255,255,255}, align=0;
static double pen_x=0,pen_y=0;
static bool in_batch=false;
struct TextCmd{ double x,y,size; int align; int r,g,b; Text s; };
static std::vector<TextCmd> texts;
long long g_polygons=0, g_frames=0, g_frame_polys=0;
// per frame, for "[snap]" and FRAME_LOG=1: every drawing call (12d charges for each) and record call
static long long s_frame_calls=0, s_frame_attr_start=0;
static Text g_snap_name="";
static void put(int x,int y,const int*c){ if(x<0||y<0||x>=g_box_w||y>=g_box_h) return; if(fb.size()<(size_t)(3*g_box_w*g_box_h)) return; int row=g_box_h-1-y; unsigned char*p=&fb[3*(row*g_box_w+x)]; p[0]=c[0];p[1]=c[1];p[2]=c[2]; }
int Start_batch_draw(const Draw_Box&){ fb.assign(3*g_box_w*g_box_h,0); texts.clear(); in_batch=true; g_frame_polys=0; s_frame_calls=0; s_frame_attr_start=g_attribute_calls; return 0; }
int Set_colour(const Draw_Box&,int r,int g,int b){ s_frame_calls++; pen[0]=r;pen[1]=g;pen[2]=b; return 0; }
int Set_fill_colour(const Draw_Box&,int r,int g,int b){ s_frame_calls++; fill[0]=r;fill[1]=g;fill[2]=b; return 0; }
int Draw_polygon(const Draw_Box&,int n,double*x,double*y){ s_frame_calls++;
  if(!in_batch){ printf("ERROR: draw outside batch\n"); return 1; }
  g_polygons++; g_frame_polys++;
  double ymin=1e18,ymax=-1e18; for(int i=1;i<=n;i++){ if(!std::isfinite(x[i])||!std::isfinite(y[i])){ printf("ERROR: non-finite polygon\n"); return 1;} ymin=std::min(ymin,y[i]); ymax=std::max(ymax,y[i]); }
  int y0=std::max(0,(int)std::floor(ymin)), y1=std::min(g_box_h-1,(int)std::ceil(ymax));
  std::vector<double> xs;
  for(int py=y0;py<=y1;py++){ double sy=py+0.5; xs.clear();
    for(int i=1;i<=n;i++){ int j=i%n+1; double ay=y[i],by=y[j]; if((ay<=sy&&by>sy)||(by<=sy&&ay>sy)){ xs.push_back(x[i]+(sy-ay)*(x[j]-x[i])/(by-ay)); } }
    std::sort(xs.begin(),xs.end());
    for(size_t k=0;k+1<xs.size();k+=2){ int xa=std::max(0,(int)std::ceil(xs[k]-0.5)), xb=std::min(g_box_w-1,(int)std::floor(xs[k+1]-0.5)); for(int px=xa;px<=xb;px++) put(px,py,fill); }
  }
  return 0; }
int Move_to(const Draw_Box&,double x,double y){ s_frame_calls++; pen_x=x;pen_y=y; return 0; }
int Draw_to(const Draw_Box&,double x,double y){ s_frame_calls++; double dx=x-pen_x,dy=y-pen_y; int n=(int)std::max(std::fabs(dx),std::fabs(dy))+1; if(n>5000)n=5000; for(int i=0;i<=n;i++) put((int)(pen_x+dx*i/n),(int)(pen_y+dy*i/n),pen); pen_x=x;pen_y=y; return 0; }
int Draw_text(const Draw_Box&,double x,double y,double s,double,const Text&t){ s_frame_calls++; texts.push_back({x,y,s,align,txtc[0],txtc[1],txtc[2],t}); return 0; }
int Set_text_align(const Draw_Box&,int a){ align=a; return 0; }
int Set_text_colour(const Draw_Box&,int r,int g,int b){ txtc[0]=r;txtc[1]=g;txtc[2]=b; return 0; }
Text g_text_font="";
int Set_text_font(const Draw_Box&,const Text&f){ g_text_font=f; return 0; }
int End_batch_draw(const Draw_Box&){ in_batch=false; g_frames++;
  if(getenv("FRAME_LOG")) printf("[frame] polys %lld draw calls %lld texts %d record calls %lld\n",g_frame_polys,s_frame_calls,(int)texts.size(),g_attribute_calls-s_frame_attr_start);
  if(!g_snap_name.empty()){
    Text base="out/"+g_snap_name; mkdir("out",0755); FILE*f=fopen((base+".ppm").c_str(),"wb"); fprintf(f,"P6 %d %d 255\n",g_box_w,g_box_h); fwrite(fb.data(),1,fb.size(),f); fclose(f);
    f=fopen((base+".txt").c_str(),"w"); for(auto&t:texts) fprintf(f,"%g\t%g\t%g\t%d\t%d\t%d\t%d\t%s\n",t.x,t.y,t.size,t.align,t.r,t.g,t.b,t.s.c_str()); fclose(f);
    printf("[snap] %s polys=%lld draw calls=%lld texts=%d record calls=%lld\n",g_snap_name.c_str(),g_frame_polys,s_frame_calls,(int)texts.size(),g_attribute_calls-s_frame_attr_start); g_snap_name=""; }
  return 0; }

// ---------------------------------------------------------------- script
struct Ev{ Text kind; Text a; double x=0,y=0; };
static std::deque<Ev> script;
static const int MENU_FIELD_BACKSPACES=50;
static void load_script(const char*path){ std::ifstream in(path); Text line; while(std::getline(in,line)){ std::istringstream s(line); Text k; if(!(s>>k)||k[0]=='#') continue;
  if(k=="tick"||k=="wait"){ int n=1; s>>n; for(int i=0;i<n;i++) script.push_back({"tick","",0,0}); }
  else if(k=="type"){ Text rest; std::getline(s,rest); if(!rest.empty()&&rest[0]==' ') rest=rest.substr(1); for(char c:rest) script.push_back({"key",Text(1,c)}); }
  else if(k=="enter"){ script.push_back({"enter",""}); }
  else if(k=="key"){ Text c; int n=1; s>>c; s>>n; if(c=="space") c=" "; for(int i=0;i<n;i++) script.push_back({"key",c}); }
  else if(k=="holdkey"){ Text c; int n=1; s>>c>>n; if(c=="space") c=" "; for(int i=0;i<n;i++){ script.push_back({"key",c}); script.push_back({"tick",""}); } }
  else if(k=="look"){ double dx,dy; s>>dx>>dy; script.push_back({"look","",dx,dy}); }
  else if(k=="click"||k=="rclick"||k=="lbdown"||k=="move"){ double x,y; s>>x>>y; script.push_back({k,"",x,y}); }
  else if(k=="capclick"){ script.push_back({"capclick",""}); }
  else if(k=="caprclick"){ script.push_back({"caprclick",""}); }
  else if(k=="snap"){ Text n; s>>n; script.push_back({"snap",n}); }
  else if(k=="input"){ Text rest; std::getline(s,rest); rest=Text_justify(rest); script.push_back({"input",rest,0,0}); }
  else if(k=="button"){ Text b; s>>b; script.push_back({"button",b}); }
  else if(k=="select"){ int n; s>>n; script.push_back({"select","",(double)n,0}); }
  else if(k=="select_name"){ Text rest; std::getline(s,rest); rest=Text_justify(rest); script.push_back({"select_name",rest,0,0}); }
  else if(k=="time"){ double t; s>>t; script.push_back({"time","",t,0}); }
  else if(k=="ui"){ Text rest; std::getline(s,rest); rest=Text_justify(rest); script.push_back({"ui",rest}); }
  else if(k=="slide"){ Text rest; std::getline(s,rest); rest=Text_justify(rest); script.push_back({"slide",rest}); }
  else if(k=="field"){ Text rest; std::getline(s,rest); rest=Text_justify(rest); auto p=rest.find('|'); script.push_back({"ui",rest.substr(0,p)}); for(int i=0;i<MENU_FIELD_BACKSPACES;i++) script.push_back({"key","bs"}); if(p!=Text::npos) for(char c:rest.substr(p+1)) script.push_back({"key",Text(1,c)}); }
  else if(k=="call"){ Text n; s>>n; script.push_back({"call",n}); }
  else if(k=="quit"){ script.push_back({"quit",""}); }
}}
std::map<Text,std::function<void()>> g_calls;
// set by hooks.cpp: where the menu widget with a label (or "#id") is, false if none
std::function<bool(const Text&,double&,double&,double&,double&)> g_ui_find;
std::function<bool(const Text&)> g_ui_reveal;   // scroll a list so the row is on screen; true if it scrolled
static void print_attr_top(){ std::vector<std::pair<long long,Text>> v; for(auto&p:g_attribute_by_name) v.push_back({p.second,p.first}); std::sort(v.rbegin(),v.rend()); for(size_t i=0;i<v.size()&&i<15;i++) printf("[attr] %lld %s\n",v[i].first,v[i].second.c_str()); }
static void print_frames(){ if(getenv("TRACE_ATTR")) print_attr_top(); printf("[frames] %lld polygons %lld attribute calls %lld type errors %lld\n", g_frames, g_polygons, g_attribute_calls, g_attribute_type_errors); }
struct FrameAtExit{ FrameAtExit(){ atexit(print_frames);} } frame_at_exit;
void push_front_click(const char*kind,double x,double y){ script.push_front({kind,"",x,y}); }
int Wait_on_events(long long&id,Text&cmd,Text&msg){
  g_sim_time += 1.0/30.0;
  while(true){
    if(script.empty()){ cmd="Panel Quit"; id=0; msg=""; return 0; }
    Ev e=script.front(); script.pop_front();
    long long box=g_widget_by_title["drawbox"];
    long long keys=g_widget_by_title["Keys"];
    if(getenv("TRACE")) printf("[event] %s %s %g %g\n",e.kind.c_str(),e.a.c_str(),e.x,e.y);
    if(e.kind=="tick"||e.kind=="look"){ // mouse move from current cursor
      double bx=g_cursor_x-100+e.x, by=100+g_box_h-g_cursor_y-e.y; id=box; cmd="mouse_move"; char b[64]; snprintf(b,64,"%g %g",bx,by); msg=b; return 0; }
    if(e.kind=="key"){ id=keys; cmd="keystroke"; msg=e.a;
      // as 12d sends them: "key bs" is Backspace (character 8), "key ctrlbs" Ctrl+Backspace (127)
      if(e.a=="bs") msg="\x08"; if(e.a=="ctrlbs") msg="\x7f";
      // "key ctrlq" is Ctrl+Q: 12d sends Ctrl + a letter as characters 1 .. 26
      if(e.a.size()==5 && e.a.compare(0,4,"ctrl")==0 && e.a[4]>='a' && e.a[4]<='z') msg=Text(1,(char)(e.a[4]-'a'+1));
      return 0; }
    if(e.kind=="enter"){ id=keys; cmd="text selected"; msg=""; return 0; }
    if(e.kind=="click"||e.kind=="rclick"||e.kind=="lbdown"||e.kind=="move"){ g_cursor_x=(int)(100+e.x); g_cursor_y=(int)(100+g_box_h-e.y); id=box; cmd= e.kind=="click"?"click_lb": e.kind=="rclick"?"click_rb": e.kind=="move"?"mouse_move":"click_lb_down"; char b[64]; snprintf(b,64,"%g %g",e.x,e.y); msg=b; return 0; }
    if(e.kind=="capclick"||e.kind=="caprclick"){ double bx=g_cursor_x-100, by=100+g_box_h-g_cursor_y; id=box; cmd= e.kind=="capclick"?"click_lb_down":"click_rb"; char b[64]; snprintf(b,64,"%g %g",bx,by); msg=b; return 0; }
    if(e.kind=="slide"){ auto p=e.a.find('|'); double x0=0,y0=0,x1=0,y1=0, f=atof(e.a.substr(p+1).c_str());
      if(g_ui_find&&g_ui_find(e.a.substr(0,p),x0,y0,x1,y1)){ double x=x0+4+f*(x1-x0-8), y=(y0+y1)/2; if(y1-y0>x1-x0){ /* a scroll bar: down from its top */ x=(x0+x1)/2; y=y1-f*(y1-y0); } script.push_front({"click","",x,y}); script.push_front({"lbdown","",x,y}); } else printf("[harness] no menu widget %s\n",e.a.c_str()); continue; }
    if(e.kind=="ui"){ double x0=0,y0=0,x1=0,y1=0; if(g_ui_find&&g_ui_find(e.a,x0,y0,x1,y1)){ double x=(x0+x1)/2,y=(y0+y1)/2; script.push_front({"click","",x,y}); script.push_front({"lbdown","",x,y}); }
      else if(g_ui_reveal&&g_ui_reveal(e.a)){ // scrolled: let the menu redraw, then try again
        script.push_front(e); for(int i=0;i<4;i++) script.push_front({"tick",""}); script.push_front({"move","",5,5}); script.push_front({"move","",g_box_w/2.0,g_box_h/2.0}); }
      else printf("[harness] no menu widget %s\n",e.a.c_str()); continue; }
    if(e.kind=="snap"){ g_snap_name=e.a; continue; }
    if(e.kind=="time"){ g_sim_time+=e.x; continue; }
    if(e.kind=="call"){ if(g_calls.count(e.a)) g_calls[e.a](); continue; }
    if(e.kind=="input"){ auto p=e.a.find('|'); g_input_value[g_widget_by_title[e.a.substr(0,p)]]=e.a.substr(p+1); continue; }
    if(e.kind=="select"){ g_list_sel[g_widget_by_title["Saved worlds"]]=(int)e.x; continue; }
    if(e.kind=="select_name"){ // the saved world, or the item in whichever list has it
      bool found=false;
      if(g_widget_by_title.count("Saved worlds")){ long long l=g_widget_by_title["Saved worlds"]; auto&v=g_list_items[l]; for(size_t i=0;i<v.size();i++) if(v[i]==e.a){ g_list_sel[l]=(int)i+1; found=true; } }
      if(!found) for(auto&kv:g_list_items) for(size_t i=0;i<kv.second.size();i++) if(kv.second[i]==e.a){ g_list_sel[kv.first]=(int)i+1; found=true; }
      if(!found) printf("[harness] no list item %s\n",e.a.c_str());
      continue; }
    if(e.kind=="button"){ id=g_widget_by_title["button:"+e.a]; cmd=e.a; msg=""; return 0; }
    if(e.kind=="quit"){ id=0; cmd="Panel Quit"; msg=""; return 0; }
  }
}
void load_script_public(const char*p){ load_script(p); }
