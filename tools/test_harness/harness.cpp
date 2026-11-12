// Test driver: rasteriser for Draw_Box calls and a scripted event source
#include "runtime.h"
#include <sstream>
#include <deque>
double g_sim_time = 13300000000.0;
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
static Text g_snap_name="";
static void put(int x,int y,const int*c){ if(x<0||y<0||x>=g_box_w||y>=g_box_h) return; int row=g_box_h-1-y; unsigned char*p=&fb[3*(row*g_box_w+x)]; p[0]=c[0];p[1]=c[1];p[2]=c[2]; }
int Start_batch_draw(const Draw_Box&){ fb.assign(3*g_box_w*g_box_h,0); texts.clear(); in_batch=true; g_frame_polys=0; return 0; }
int Set_colour(const Draw_Box&,int r,int g,int b){ pen[0]=r;pen[1]=g;pen[2]=b; return 0; }
int Set_fill_colour(const Draw_Box&,int r,int g,int b){ fill[0]=r;fill[1]=g;fill[2]=b; return 0; }
int Draw_polygon(const Draw_Box&,int n,double*x,double*y){
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
int Move_to(const Draw_Box&,double x,double y){ pen_x=x;pen_y=y; return 0; }
int Draw_to(const Draw_Box&,double x,double y){ double dx=x-pen_x,dy=y-pen_y; int n=(int)std::max(std::fabs(dx),std::fabs(dy))+1; if(n>5000)n=5000; for(int i=0;i<=n;i++) put((int)(pen_x+dx*i/n),(int)(pen_y+dy*i/n),pen); pen_x=x;pen_y=y; return 0; }
int Draw_text(const Draw_Box&,double x,double y,double s,double,const Text&t){ texts.push_back({x,y,s,align,txtc[0],txtc[1],txtc[2],t}); return 0; }
int Set_text_align(const Draw_Box&,int a){ align=a; return 0; }
int Set_text_colour(const Draw_Box&,int r,int g,int b){ txtc[0]=r;txtc[1]=g;txtc[2]=b; return 0; }
Text g_text_font="";
int Set_text_font(const Draw_Box&,const Text&f){ g_text_font=f; return 0; }
int End_batch_draw(const Draw_Box&){ in_batch=false; g_frames++;
  if(!g_snap_name.empty()){
    Text base="out/"+g_snap_name; mkdir("out",0755); FILE*f=fopen((base+".ppm").c_str(),"wb"); fprintf(f,"P6 %d %d 255\n",g_box_w,g_box_h); fwrite(fb.data(),1,fb.size(),f); fclose(f);
    f=fopen((base+".txt").c_str(),"w"); for(auto&t:texts) fprintf(f,"%g\t%g\t%g\t%d\t%d\t%d\t%d\t%s\n",t.x,t.y,t.size,t.align,t.r,t.g,t.b,t.s.c_str()); fclose(f);
    printf("[snap] %s polys=%lld\n",g_snap_name.c_str(),g_frame_polys); g_snap_name=""; }
  return 0; }

// ---------------------------------------------------------------- script
struct Ev{ Text kind; Text a; double x=0,y=0; };
static std::deque<Ev> script;
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
  else if(k=="call"){ Text n; s>>n; script.push_back({"call",n}); }
  else if(k=="quit"){ script.push_back({"quit",""}); }
}}
std::map<Text,std::function<void()>> g_calls;
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
    long long keys=g_widget_by_title["Keys (click here if the keys stop working)"];
    if(getenv("TRACE")) printf("[event] %s %s %g %g\n",e.kind.c_str(),e.a.c_str(),e.x,e.y);
    if(e.kind=="tick"||e.kind=="look"){ // mouse move from current cursor
      double bx=g_cursor_x-100+e.x, by=100+g_box_h-g_cursor_y-e.y; id=box; cmd="mouse_move"; char b[64]; snprintf(b,64,"%g %g",bx,by); msg=b; return 0; }
    if(e.kind=="key"){ id=keys; cmd="keystroke"; msg=e.a; return 0; }
    if(e.kind=="enter"){ id=keys; cmd="text selected"; msg=""; return 0; }
    if(e.kind=="click"||e.kind=="rclick"||e.kind=="lbdown"||e.kind=="move"){ g_cursor_x=(int)(100+e.x); g_cursor_y=(int)(100+g_box_h-e.y); id=box; cmd= e.kind=="click"?"click_lb": e.kind=="rclick"?"click_rb": e.kind=="move"?"mouse_move":"click_lb_down"; char b[64]; snprintf(b,64,"%g %g",e.x,e.y); msg=b; return 0; }
    if(e.kind=="capclick"||e.kind=="caprclick"){ double bx=g_cursor_x-100, by=100+g_box_h-g_cursor_y; id=box; cmd= e.kind=="capclick"?"click_lb_down":"click_rb"; char b[64]; snprintf(b,64,"%g %g",bx,by); msg=b; return 0; }
    if(e.kind=="snap"){ g_snap_name=e.a; continue; }
    if(e.kind=="time"){ g_sim_time+=e.x; continue; }
    if(e.kind=="call"){ if(g_calls.count(e.a)) g_calls[e.a](); continue; }
    if(e.kind=="input"){ auto p=e.a.find('|'); g_input_value[g_widget_by_title[e.a.substr(0,p)]]=e.a.substr(p+1); continue; }
    if(e.kind=="select"){ g_list_sel[g_widget_by_title["Saved worlds"]]=(int)e.x; continue; }
    if(e.kind=="select_name"){ long long l=g_widget_by_title["Saved worlds"]; auto&v=g_list_items[l]; for(size_t i=0;i<v.size();i++) if(v[i]==e.a) g_list_sel[l]=(int)i+1; continue; }
    if(e.kind=="button"){ id=g_widget_by_title["button:"+e.a]; cmd=e.a; msg=""; return 0; }
    if(e.kind=="quit"){ id=0; cmd="Panel Quit"; msg=""; return 0; }
  }
}
void load_script_public(const char*p){ load_script(p); }
