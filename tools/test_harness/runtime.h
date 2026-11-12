// C++ stand-ins for the 12dPL library calls used by the macro (test harness only)
#pragma once
#include <string>
#include <vector>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <map>
#include <functional>
#include <algorithm>
#include <sys/stat.h>
#include <dirent.h>
#ifdef _WIN32
#include <direct.h>
#include <io.h>
#endif
typedef int Integer;
typedef long long Integer64;
typedef double Real;
typedef std::string Text;

// ---------------------------------------------------------------- maths / text
inline double Floor(double v){ return std::floor(v); }
inline double Sqrt(double v){ return std::sqrt(v); }
inline double Sin(double v){ return std::sin(v); }
inline double Cos(double v){ return std::cos(v); }
inline double Absolute(double v){ return std::fabs(v); }
inline int Absolute(int v){ return v<0?-v:v; }
inline Text To_text(int v){ return std::to_string(v); }
inline Text To_text(long long v){ return std::to_string(v); }
inline Text To_text(double v){ char b[64]; snprintf(b,64,"%g",v); return b; }
inline Text To_text(double v,int d){ char b[64]; snprintf(b,64,"%.*f",d,v); return b; }
inline int Text_length(const Text&t){ return (int)t.size(); }
inline Text Get_subtext(const Text&t,int s,int e){ if(s<1)s=1; if(e>(int)t.size())e=t.size(); if(e<s) return ""; return t.substr(s-1,e-s+1); }
inline int Find_text(const Text&t,const Text&f){ auto p=t.find(f); return p==Text::npos?0:(int)p+1; }
inline Text Text_lower(Text t){ for(auto&c:t)c=tolower(c); return t; }
inline Text Text_justify(Text t){ size_t a=t.find_first_not_of(' '); if(a==Text::npos) return ""; size_t b=t.find_last_not_of(' '); return t.substr(a,b-a+1); }
inline int From_text(const Text&t,int&v){ char*e; long r=strtol(t.c_str(),&e,10); if(e==t.c_str()) return 1; v=(int)r; return 0; }
inline int From_text(const Text&t,double&v){ char*e; double r=strtod(t.c_str(),&e); if(e==t.c_str()) return 1; v=r; return 0; }
struct Dynamic_Text { std::vector<Text> items; };
inline int From_text(const Text&t,Dynamic_Text&d){ int n=0; size_t i=0; while(i<t.size()){ while(i<t.size()&&t[i]==' ')i++; if(i>=t.size())break; size_t j=i; while(j<t.size()&&t[j]!=' ')j++; d.items.push_back(t.substr(i,j-i)); n++; i=j;} return n; }
inline int Null(Dynamic_Text&d){ d.items.clear(); return 0; }
inline int Append(const Text&t,Dynamic_Text&d){ d.items.push_back(t); return 0; }
inline int Get_item(Dynamic_Text&d,int i,Text&t){ if(i<1||i>(int)d.items.size()) return 1; t=d.items[i-1]; return 0; }
inline int Get_number_of_items(Dynamic_Text&d,int&n){ n=d.items.size(); return 0; }
inline void Print(const Text&t){ fputs(t.c_str(),stdout); }
inline void Print(int v){ printf("%d",v); }
inline void Print(double v){ printf("%g",v); }
inline void Print(){ printf("\n"); }

// ---------------------------------------------------------------- random / time
extern double g_sim_time;
#ifndef CUBELAND_DESKTOP
inline int Get_time(double&t){ t=g_sim_time; return 0; }
inline int Get_time(int&t){ t=(int)g_sim_time; return 0; }
#else
int Get_time(double&t);
int Get_time(int&t);
#endif
static unsigned long long g_rng=1;
inline void Set_random_number(int seed,int){ g_rng=(unsigned long long)(unsigned)seed*2654435761ULL+12345; }
inline double Get_random_number_closed(){ g_rng=g_rng*6364136223846793005ULL+1442695040888963407ULL; return (double)((g_rng>>11)&((1ULL<<53)-1))/(double)((1ULL<<53)-1); }

#ifndef CUBELAND_DESKTOP
// ---------------------------------------------------------------- widgets
struct Widget { long long id=0; Text title; int kind=0; };
extern long long g_next_id;
extern std::map<Text,long long> g_widget_by_title;
extern std::map<long long,Text> g_input_value;
extern std::map<long long,std::vector<Text>> g_list_items;
extern std::map<long long,int> g_list_sel;
inline Widget make_widget(const Text&t,int k){ Widget w; w.id=++g_next_id; w.title=t; w.kind=k; g_widget_by_title[t]=w.id; return w; }
struct Panel:Widget{}; struct Vertical_Group:Widget{}; struct Horizontal_Group:Widget{};
struct Message_Box:Widget{}; struct Colour_Message_Box:Message_Box{};
struct Input_Box:Widget{}; struct File_Box:Widget{}; struct List_Box:Widget{}; struct Button:Widget{};
struct Draw_Box:Widget{ int w=0,h=0; };
template<class T> T mk(const Text&t,int k){ T x; Widget w=make_widget(t,k); x.id=w.id; x.title=t; x.kind=k; return x; }
inline Panel Create_panel(const Text&t){ return mk<Panel>("panel:"+t,1); }
inline Panel Create_panel(const Text&t,int){ return mk<Panel>("panel:"+t,1); }
inline Vertical_Group Create_vertical_group(int){ return mk<Vertical_Group>("vg"+std::to_string(g_next_id),2); }
inline Horizontal_Group Create_button_group(){ return mk<Horizontal_Group>("hg"+std::to_string(g_next_id),2); }
inline Colour_Message_Box Create_colour_message_box(const Text&t){ return mk<Colour_Message_Box>("msg"+std::to_string(g_next_id),3); }
inline Input_Box Create_input_box(const Text&t,const Message_Box&){ return mk<Input_Box>(t,4); }
inline File_Box Create_file_box(const Text&t,const Message_Box&,int,const Text&){ return mk<File_Box>(t,4); }
inline List_Box Create_list_box(const Text&t,const Message_Box&,int){ return mk<List_Box>(t,5); }
inline Button Create_button(const Text&t,const Text&r){ return mk<Button>("button:"+r,6); }
inline Button Create_finish_button(const Text&t,const Text&r){ return mk<Button>("button:"+r,6); }
extern int g_box_w, g_box_h;
inline Draw_Box Create_draw_box(int w,int h,int){ Draw_Box d=mk<Draw_Box>("drawbox",7); g_box_w=w; g_box_h=h; return d; }
template<class A,class B> int Append(const A&,const B&){ return 0; }
inline int Show_widget(const Widget&){ return 0; }
inline int Hide_widget(const Widget&){ return 0; }
inline int Set_focus(const Widget&){ return 0; }
inline int Set_sizing_constraints(const Widget&,int,int){ return 0; }
inline int Set_notify_resizing(const Widget&){ return 0; }
inline int Set_exit_code(const Text&){ return 0; }
inline long long Get_id64(const Widget&w){ return w.id; }
extern Text g_last_message;
inline int Set_data(const Colour_Message_Box&,const Text&t){ g_last_message=t; printf("[message] %s\n",t.c_str()); return 0; }
inline int Set_data(const Input_Box&b,const Text&t){ g_input_value[b.id]=t; return 0; }
inline int Get_data(const Input_Box&b,Text&t){ t=g_input_value[b.id]; return 0; }
inline int Set_data(const File_Box&b,const Text&t){ g_input_value[b.id]=t; return 0; }
inline int Get_data(const File_Box&b,Text&t){ t=g_input_value[b.id]; return 0; }
inline int Get_number_of_items(const List_Box&b,int&n){ n=g_list_items[b.id].size(); return 0; }
inline int Delete_item(const List_Box&b,int p){ auto&v=g_list_items[b.id]; if(p>=1&&p<=(int)v.size()) v.erase(v.begin()+p-1); return 0; }
inline int Add_item(const List_Box&b,const Text&t){ g_list_items[b.id].push_back(t); return 0; }
inline int Set_selection(const List_Box&b,int p){ g_list_sel[b.id]=p; return 0; }
inline int Get_selection(const List_Box&b,int&p){ p=g_list_sel[b.id]; return 0; }
inline int Get_item(const List_Box&b,int p,Text&t){ auto&v=g_list_items[b.id]; if(p<1||p>(int)v.size()) return 1; t=v[p-1]; return 0; }
inline int Get_size(const Draw_Box&,int&w,int&h){ w=g_box_w; h=g_box_h; return 0; }
inline int Get_position(const Widget&,int&x,int&y){ x=100; y=100; return 0; }
extern int g_cursor_x, g_cursor_y;
inline int Get_cursor_position(int&x,int&y){ x=g_cursor_x; y=g_cursor_y; return 0; }
inline int Set_cursor_position(int x,int y){ g_cursor_x=x; g_cursor_y=y; return 0; }
int Wait_on_events(long long&id,Text&cmd,Text&msg);

// ---------------------------------------------------------------- drawing
int Start_batch_draw(const Draw_Box&); int End_batch_draw(const Draw_Box&);
int Set_colour(const Draw_Box&,int,int,int); int Set_fill_colour(const Draw_Box&,int,int,int);
int Draw_polygon(const Draw_Box&,int,double*,double*);
int Move_to(const Draw_Box&,double,double); int Draw_to(const Draw_Box&,double,double);
int Draw_text(const Draw_Box&,double,double,double,double,const Text&);
int Set_text_align(const Draw_Box&,int); int Set_text_colour(const Draw_Box&,int,int,int); int Set_text_font(const Draw_Box&,const Text&);
inline int Set_bk_mode(const Draw_Box&,int){ return 0; }

#else
// ---------------------------------------------------------------- widgets (desktop: implemented in tools/desktop/desktop.cpp)
struct Widget { long long id=0; Text title; int kind=0; };
extern long long g_next_id;
struct Panel:Widget{}; struct Vertical_Group:Widget{}; struct Horizontal_Group:Widget{};
struct Message_Box:Widget{}; struct Colour_Message_Box:Message_Box{};
struct Input_Box:Widget{}; struct File_Box:Widget{}; struct List_Box:Widget{}; struct Button:Widget{};
struct Draw_Box:Widget{ int w=0,h=0; };
Panel Create_panel(const Text&t); Panel Create_panel(const Text&t,int);
Vertical_Group Create_vertical_group(int); Horizontal_Group Create_button_group();
Colour_Message_Box Create_colour_message_box(const Text&t);
Input_Box Create_input_box(const Text&t,const Message_Box&);
File_Box Create_file_box(const Text&t,const Message_Box&,int,const Text&);
List_Box Create_list_box(const Text&t,const Message_Box&,int);
Button Create_button(const Text&t,const Text&r); Button Create_finish_button(const Text&t,const Text&r);
Draw_Box Create_draw_box(int w,int h,int);
int Append(const Widget&child,const Widget&parent);
int Show_widget(const Widget&); int Hide_widget(const Widget&); int Set_focus(const Widget&);
int Set_sizing_constraints(const Widget&,int,int); int Set_notify_resizing(const Widget&);
inline int Set_exit_code(const Text&){ return 0; }
inline long long Get_id64(const Widget&w){ return w.id; }
int Set_data(const Colour_Message_Box&,const Text&t);
int Set_data(const Input_Box&b,const Text&t); int Get_data(const Input_Box&b,Text&t);
int Set_data(const File_Box&b,const Text&t); int Get_data(const File_Box&b,Text&t);
int Get_number_of_items(const List_Box&b,int&n); int Delete_item(const List_Box&b,int p); int Add_item(const List_Box&b,const Text&t);
int Set_selection(const List_Box&b,int p); int Get_selection(const List_Box&b,int&p); int Get_item(const List_Box&b,int p,Text&t);
int Get_size(const Draw_Box&,int&w,int&h); int Get_position(const Widget&,int&x,int&y);
int Get_cursor_position(int&x,int&y); int Set_cursor_position(int x,int y);
int Wait_on_events(long long&id,Text&cmd,Text&msg);
int Start_batch_draw(const Draw_Box&); int End_batch_draw(const Draw_Box&);
int Set_colour(const Draw_Box&,int,int,int); int Set_fill_colour(const Draw_Box&,int,int,int);
int Draw_polygon(const Draw_Box&,int,double*,double*);
int Move_to(const Draw_Box&,double,double); int Draw_to(const Draw_Box&,double,double);
int Draw_text(const Draw_Box&,double,double,double,double,const Text&);
int Set_text_align(const Draw_Box&,int); int Set_text_colour(const Draw_Box&,int,int,int); int Set_text_font(const Draw_Box&,const Text&);
inline int Set_bk_mode(const Draw_Box&,int){ return 0; }
#endif

// ---------------------------------------------------------------- files
inline Text fix_path(Text p){ for(auto&c:p) if(c=='\\') c='/'; return p; }
struct File { std::FILE* f=nullptr; };
inline int File_open(const Text&n,const Text&m,const Text&,File&f){ const char*mode=m=="w"?"w":(m=="rb"?"rb":"r"); f.f=fopen(fix_path(n).c_str(), mode); return f.f?0:1; }
// Binary reads: little-endian, like 12d on Windows
inline int File_read(File&f,int&v){ unsigned char b[4]; if(!f.f||fread(b,1,4,f.f)!=4) return 1; v=(int)((unsigned)b[0]|((unsigned)b[1]<<8)|((unsigned)b[2]<<16)|((unsigned)b[3]<<24)); return 0; }
inline int Set_char(Text&t,int n,int c){ if(n<1||n>(int)t.size()) return 1; t[n-1]=(char)c; return 0; }
inline int File_read_short(File&f,int&v){ unsigned char b[2]; if(!f.f||fread(b,1,2,f.f)!=2) return 1; v=(short)(b[0]|(b[1]<<8)); return 0; }
inline int File_read(File&f,int n,Text&t){ t.assign(n,' '); if(!f.f||n<0||(int)fread(&t[0],1,n,f.f)!=n) return 1; return 0; }
inline int File_seek(File&f,int pos){ return f.f?fseek(f.f,pos,SEEK_SET):1; }
inline int File_tell(File&f,int&pos){ if(!f.f) return 1; pos=(int)ftell(f.f); return 0; }
inline int File_close(File&f){ if(f.f) fclose(f.f); f.f=nullptr; return 0; }
inline int File_write_line(File&f,const Text&t){ fputs(t.c_str(),f.f); fputc('\n',f.f); return 0; }
inline int File_read_line(File&f,Text&t){ char buf[65536]; if(!fgets(buf,sizeof buf,f.f)) return -1; t=buf; while(!t.empty()&&(t.back()=='\n'||t.back()=='\r')) t.pop_back(); return 0; }
inline int File_exists(const Text&n){ struct stat s; return stat(fix_path(n).c_str(),&s)==0; }
inline int Directory_exists(const Text&n){ struct stat s; return stat(fix_path(n).c_str(),&s)==0 && S_ISDIR(s.st_mode); }
#ifdef _WIN32
inline int Directory_create(const Text&n){ return mkdir(fix_path(n).c_str()); }
#else
inline int Directory_create(const Text&n){ return mkdir(fix_path(n).c_str(),0755); }
#endif
inline int Delete_files(const Text&n){ return remove(fix_path(n).c_str()); }
inline int List_files_in_folder(const Text&folder,const Text&pat,int&count,Dynamic_Text&names){
  count=0; DIR*d=opendir(fix_path(folder).c_str()); if(!d) return 1; Text ext=pat.substr(1);
  while(auto e=readdir(d)){ Text n=e->d_name; if(n.size()>ext.size()&&n.compare(n.size()-ext.size(),ext.size(),ext)==0){ names.items.push_back(n); count++; } }
  closedir(d); return 0; }
inline int Get_number_of_command_arguments(){ return 0; }
inline int Get_command_argument(int,Text&t){ t=""; return 0; }

// ---------------------------------------------------------------- attributes
// Value semantics (copying an Attributes copies its fields) and
// strict types (reading a field as the wrong type fails and is
// reported), so code that only works with 12d's handle behaviour or
// mixes field types shows up in testing.
struct AttrValue { int type=0; long long i=0; double r=0; Text t; };
struct Attributes { std::map<Text,AttrValue> fields; std::vector<Text> order; };
extern long long g_attribute_calls;
extern long long g_attribute_type_errors;
extern std::map<Text,long long> g_attribute_by_name;
inline AttrValue* attr_find(Attributes&a,const Text&n){ ++g_attribute_calls; if(getenv("TRACE_ATTR")) ++g_attribute_by_name[n]; auto it=a.fields.find(n); return it==a.fields.end()?nullptr:&it->second; }
inline void attr_type_error(const Text&n,int want,int have){ if(++g_attribute_type_errors<=20) printf("ERROR: attribute %s read as type %d but is type %d\n",n.c_str(),want,have); }
inline int attr_put(Attributes&a,const Text&n,int type,AttrValue v){ ++g_attribute_calls; auto it=a.fields.find(n);
  if(it!=a.fields.end()&&it->second.type!=type){ if(++g_attribute_type_errors<=20) printf("ERROR: attribute %s set as type %d but is type %d\n",n.c_str(),type,it->second.type); return 1; }
  if(it==a.fields.end()) a.order.push_back(n); v.type=type; a.fields[n]=v; return 0; }
inline int Set_attribute(Attributes&a,const Text&n,int v){ AttrValue x; x.i=v; return attr_put(a,n,1,x); }
inline int Set_attribute(Attributes&a,const Text&n,double v){ AttrValue x; x.r=v; return attr_put(a,n,2,x); }
inline int Set_attribute(Attributes&a,const Text&n,const Text&v){ AttrValue x; x.t=v; return attr_put(a,n,3,x); }
inline int Set_attribute(Attributes&a,const Text&n,const char*v){ return Set_attribute(a,n,Text(v)); }
inline int Get_attribute(Attributes&a,const Text&n,int&v){ AttrValue*x=attr_find(a,n); if(!x) return 1; if(x->type!=1){ attr_type_error(n,1,x->type); return 2; } v=(int)x->i; return 0; }
inline int Get_attribute(Attributes&a,const Text&n,double&v){ AttrValue*x=attr_find(a,n); if(!x) return 1; if(x->type!=2){ attr_type_error(n,2,x->type); return 2; } v=x->r; return 0; }
inline int Get_attribute(Attributes&a,const Text&n,Text&v){ AttrValue*x=attr_find(a,n); if(!x) return 1; if(x->type!=3){ attr_type_error(n,3,x->type); return 2; } v=x->t; return 0; }
inline int Attribute_exists(Attributes&a,const Text&n){ return attr_find(a,n)?1:0; }
inline int Attribute_delete(Attributes&a,const Text&n){ a.fields.erase(n); a.order.erase(std::remove(a.order.begin(),a.order.end(),n),a.order.end()); return 0; }
inline int Attribute_delete_all(Attributes&a){ a.fields.clear(); a.order.clear(); return 0; }
inline int Get_number_of_attributes(Attributes&a,int&n){ n=(int)a.fields.size(); return 0; }
inline const Text* attr_name_at(Attributes&a,int no){ if(no<1||no>(int)a.order.size()) return nullptr; return &a.order[no-1]; }
inline int Get_attribute_name(Attributes&a,int no,Text&n){ const Text*p=attr_name_at(a,no); if(!p) return 1; n=*p; return 0; }
inline int Get_attribute(Attributes&a,int no,int&v){ const Text*p=attr_name_at(a,no); if(!p) return 1; AttrValue&x=a.fields[*p]; if(x.type!=1) return 2; v=(int)x.i; return 0; }
inline int Get_attribute(Attributes&a,int no,double&v){ const Text*p=attr_name_at(a,no); if(!p) return 1; AttrValue&x=a.fields[*p]; if(x.type!=2) return 2; v=x.r; return 0; }
inline int Get_attribute(Attributes&a,int no,Text&v){ const Text*p=attr_name_at(a,no); if(!p) return 1; AttrValue&x=a.fields[*p]; if(x.type!=3) return 2; v=x.t; return 0; }
