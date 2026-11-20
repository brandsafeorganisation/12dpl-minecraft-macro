// Test hooks appended to the translated macro (they can see its globals and functions)
#include <sstream>
extern std::map<Text,std::function<void()>> g_calls;
extern int g_box_w, g_box_h;
void push_front_click(const char*kind,double x,double y);
static double px(){ double x,y,z; player_position(g_player,x,y,z); return x; }
static double py(){ double x,y,z; player_position(g_player,x,y,z); return y; }
static double pz(){ double x,y,z; player_position(g_player,x,y,z); return z; }
static double s_saved_x=0,s_saved_y=0,s_saved_z=0;
static int s_ox=0,s_oy=0,s_oz=0;
static void set_look(double yaw,double pitch){ player_set_look(g_player,yaw,pitch); }
extern long long g_attribute_calls;
static void dump(){
  printf("[dump] attribute calls so far %lld\n",g_attribute_calls);
  double x,y,z,yaw,pitch; player_position(g_player,x,y,z); player_look(g_player,yaw,pitch);
  printf("[dump] pos %.2f %.2f %.2f yaw %.2f pitch %.2f health %d dead %d ground %d water %d sel %d\n",x,y,z,yaw,pitch,player_health(g_player),player_is_dead(g_player),player_on_ground(g_player),player_in_water(g_player),player_selected(g_player));
  printf("[dump] inventory:"); for(int s=1;s<=36;s++) if(slot_item(g_inventory,s)) printf(" [%d]%s x%d%s",s,item_name(slot_item(g_inventory,s)).c_str(),slot_count(g_inventory,s),slot_damage(g_inventory,s)?(" worn "+std::to_string(slot_damage(g_inventory,s))).c_str():"");
  printf("  cursor %d x%d\n",slot_item(g_inventory,0),slot_count(g_inventory,0));
  printf("[dump] grid:"); for(int s=1;s<=9;s++) if(slot_item(g_grid,s)) printf(" [%d]%s x%d",s,item_name(slot_item(g_grid,s)).c_str(),slot_count(g_grid,s)); printf("  match %d\n",crafting_match(g_book,g_grid));
  int drops=0; for(int d=1;d<=MAX_DROPS;d++) drops+=drop_used(g_drops,d);
  int tx,ty,tz; player_target_cell(g_player,tx,ty,tz);
  printf("[dump] cows %d drops %d edits %d target %d (%d %d %d) screen %d faces %d polys %d sections %d builds %d overflow %d\n",cows_alive_count(g_cows),drops,g_edit_count,player_target_kind(g_player),tx,ty,tz,ui_screen(g_ui),g_stat_faces,g_stat_polygons,g_stat_sections,g_mesh_builds,g_mesh_overflow);
  for(int f=1;f<=MAX_FURNACES;f++) if(furnace_used(g_furnaces,f)){ int fx,fy,fz; furnace_cell(g_furnaces,f,fx,fy,fz);
    printf("[dump] furnace %d at %d %d %d in %d x%d fuel %d x%d out %d x%d burn %.1f prog %.1f\n",f,fx,fy,fz,
      slot_item(g_furnaces,furnace_slot(f,1)),slot_count(g_furnaces,furnace_slot(f,1)),slot_item(g_furnaces,furnace_slot(f,2)),slot_count(g_furnaces,furnace_slot(f,2)),
      slot_item(g_furnaces,furnace_slot(f,3)),slot_count(g_furnaces,furnace_slot(f,3)),furnace_burn_left(g_furnaces,f),furnace_progress(g_furnaces,f)); }
}
static void ui_click_slot(int slot,const char*kind){ double x,y,s; if(ui_slot_rect(ui_screen(g_ui),grid_width(g_grid),slot,g_box_w,g_box_h,x,y,s)) push_front_click(kind,x+s/2,y+s/2); else printf("no slot rect %d\n",slot); }
static int find_item(int item){ for(int s=1;s<=36;s++) if(slot_item(g_inventory,s)==item) return s; return 0; }
static void place_in_grid(int item,int grid_slot){ // pick up the stack, right click one into the grid slot, put the rest back
  int s=find_item(item); if(!s){ printf("[hook] no %s\n",item_name(item).c_str()); return; }
  ui_click_slot(s,"click");          // these are pushed to the FRONT, so push in reverse order
  ui_click_slot(40+grid_slot,"rclick");
  ui_click_slot(s,"click"); }
extern std::function<bool(const Text&,double&,double&,double&,double&)> g_ui_find;
extern std::function<bool(const Text&)> g_ui_reveal;
static bool ui_find(const Text&label,double&x,double&y,double&x1,double&y1){
  int n=menu_widgets(g_menu);
  // "lan:<n>": row n of the LAN worlds on Play Multiplayer
  if(label.compare(0,4,"lan:")==0){ for(int w=1;w<=n;w++) if(record_integer_at(g_menu,ATTR_MENU_ID,w)==W_WORLD_ROW+atoi(label.c_str()+4)){
        x=record_real_at(g_menu,ATTR_MENU_X0,w); x1=record_real_at(g_menu,ATTR_MENU_X1,w); y=record_real_at(g_menu,ATTR_MENU_Y0,w); y1=record_real_at(g_menu,ATTR_MENU_Y1,w); return true; }
    return false; }
  // "row:<world name>": that world's row in the world list
  if(label.compare(0,4,"row:")==0){ for(int w=1;w<=n;w++){ int id=record_integer_at(g_menu,ATTR_MENU_ID,w);
      if(id>W_WORLD_ROW&&id<=W_WORLD_ROW+MAX_LISTED_WORLDS&&record_text_at(g_worlds,ATTR_WL_NAME,id-W_WORLD_ROW)==label.substr(4)){
        x=record_real_at(g_menu,ATTR_MENU_X0,w); x1=record_real_at(g_menu,ATTR_MENU_X1,w); y=record_real_at(g_menu,ATTR_MENU_Y0,w); y1=record_real_at(g_menu,ATTR_MENU_Y1,w); return true; } }
    return false; }
  for(int pass=0;pass<2;pass++) for(int w=1;w<=n;w++){
    if(!record_integer_at(g_menu,ATTR_MENU_ENABLED,w)) continue;
    Text l=record_text_at(g_menu,ATTR_MENU_LABEL,w); int id=record_integer_at(g_menu,ATTR_MENU_ID,w);
    bool hit= label.size()>1&&label[0]=='#' ? id==atoi(label.c_str()+1) : (pass==0 ? l==label : l.compare(0,label.size(),label)==0);
    if(!hit) continue;
    x=record_real_at(g_menu,ATTR_MENU_X0,w); x1=record_real_at(g_menu,ATTR_MENU_X1,w); y=record_real_at(g_menu,ATTR_MENU_Y0,w); y1=record_real_at(g_menu,ATTR_MENU_Y1,w);
    if(getenv("TRACE")) printf("[ui] %s at %.0f %.0f\n",label.c_str(),x,y);
    return true; }
  // then the game menu's buttons (drawn by the HUD, not in the menu record)
  const char* pause[]={"","Back to Game","Options...","Controls...","Save Game","Open to LAN","Save and Quit to Title"};
  for(int b=1;b<=PAUSE_BUTTONS;b++) if(label==pause[b]){ hud_pause_button_rect(g_box_w,g_box_h,b,x,y,x1,y1); return true; }
  return false; }
static void register_hooks(){
  g_ui_find=ui_find;
  // "row:<world>" off screen: scroll the world list to it
  g_ui_reveal=[](const Text&label){ if(label.compare(0,4,"row:")!=0) return false; int c=record_integer(g_worlds,ATTR_WL_COUNT);
    for(int i=1;i<=c;i++) if(record_text_at(g_worlds,ATTR_WL_NAME,i)==label.substr(4)){ int before=menu_scroll(g_menu); menu_set_scroll(g_menu,i-1,c,menu_world_rows_shown(g_box_h)); return menu_scroll(g_menu)!=before; }
    return false; };
  g_calls["menu"]=[]{ int n=menu_widgets(g_menu); printf("[menu]"); for(int w=1;w<=n;w++) printf(" [%d %s%s]",record_integer_at(g_menu,ATTR_MENU_ID,w),record_text_at(g_menu,ATTR_MENU_LABEL,w).c_str(),record_integer_at(g_menu,ATTR_MENU_ENABLED,w)?"":" (off)"); printf("\n"); };
  g_calls["worlds"]=[]{ int n=record_integer(g_worlds,ATTR_WL_COUNT); for(int e=1;e<=n;e++) printf("[world] %s played %d date '%s' mode %d version %d %s picture %d\n",record_text_at(g_worlds,ATTR_WL_NAME,e).c_str(),record_integer_at(g_worlds,ATTR_WL_PLAYED,e),record_text_at(g_worlds,ATTR_WL_DATE,e).c_str(),record_integer_at(g_worlds,ATTR_WL_MODE,e),record_integer_at(g_worlds,ATTR_WL_VERSION,e),record_text_at(g_worlds,ATTR_WL_VERSION_TEXT,e).c_str(),record_integer_at(g_worlds,ATTR_WL_THUMB,e)); };
  g_calls["dump"]=dump;
  g_calls["test_reports"]=[]{ if(system("ls cubeland_worlds/test_reports | sed 's/^/[reports] /'; cat cubeland_worlds/test_reports/progress.txt | sed 's/^/[progress] /'")){} };
#ifdef CUBELAND_REAL_CLOCK
  g_calls["domains"]=[]{ for(int id=1;id<=TEST_FUNCTION_COUNT;id++){ test_registry_info(id,g_test_info); if(record_text(g_test_info,ATTR_TEST_WHY)!="") continue;
      test_params_prepare(g_test_info,g_test_params); printf("[domains] %s | %s\n",record_text(g_test_info,ATTR_TEST_NAME).c_str(),test_domains_text(g_test_params).c_str()); } };
#endif
  g_calls["opened"]=[]{ printf("[opened] %s\n", g_opened_file.c_str()); };
  g_calls["mode"]=[]{ printf("[mode] %s flying %d spectator %d creative %d survival %d screen %d tabs %d search '%s' matches %d scroll %d cursor %s x%d edits %d target %d\n",
      player_game_mode_name(player_game_mode(g_player)).c_str(),player_flying(g_player),player_spectator(g_player),player_creative(g_player),player_survival(g_player),
      ui_screen(g_ui),record_integer(g_ui,ATTR_UI_TABS),ui_search(g_ui).c_str(),ui_creative_count(g_ui),record_integer(g_ui,ATTR_UI_SCROLL),
      item_name(slot_item(g_inventory,0)).c_str(),slot_count(g_inventory,0),g_edit_count,player_target_kind(g_player)); };
  g_calls["inside_stone"]=[]{ int x=(int)px(),z=(int)pz(); int t=world_top_solid_y(x,z); printf("[hook] top %d at %d %d, player y %.2f block at eye %d\n",t,x,z,py(),world_get_block(x,(int)floor(py()+1.62),z)); };
  g_calls["dump_textures"]=[]{ // every texture pixel as r,g,b ("-" see-through), for make_test_pack.py check
    FILE*f=fopen("out/textures.txt","w");
    for(int t=1;t<=NUM_TEXTURES;t++){ fprintf(f,"%d",t);
      for(int v=1;v<=16;v++) for(int u=1;u<=16;u++){ int i=texture_get(t,u,v);
        if(i==0) fprintf(f," -"); else { int s=texture_palette_index(t,i); fprintf(f," %d,%d,%d",g_tex_pal_r[s],g_tex_pal_g[s],g_tex_pal_b[s]); } }
      fprintf(f,"\n"); }
    fclose(f); printf("[hook] wrote out/textures.txt (%d rectangles)\n",g_rect_total); };
  g_calls["rename_texture_dump"]=[]{ rename("out/textures.txt","out/textures_folder.txt"); };
  g_calls["give_iron"]=[]{ inventory_add(g_inventory,ITEM_IRON_INGOT,6); inventory_add(g_inventory,ITEM_STICK,4); inventory_add(g_inventory,ITEM_STONE_PICKAXE,1); };
  g_calls["texstats"]=[]{ int total=0; for(int t=1;t<=NUM_TEXTURES;t++){ printf("[tex] %d rects %d base %d sprite %d\n",t,g_tex_rect_count[t],g_tex_base[t],g_tex_is_sprite[t]); total+=g_tex_rect_count[t]; } printf("[tex] total %d (%d)\n",total,g_rect_total); };
  g_calls["give"]=[]{ inventory_add(g_inventory,6,4); inventory_add(g_inventory,3,16); inventory_add(g_inventory,65,3); inventory_add(g_inventory,4,10); };
  g_calls["give_wood"]=[]{ inventory_add(g_inventory,ITEM_OAK_LOG,5); };
  g_calls["give_tools"]=[]{ inventory_add(g_inventory,ITEM_WOODEN_PICKAXE,1); inventory_add(g_inventory,ITEM_STONE_SWORD,1); inventory_add(g_inventory,ITEM_COAL,5); inventory_add(g_inventory,ITEM_STICK,4); inventory_add(g_inventory,ITEM_POPPY,2); inventory_add(g_inventory,ITEM_SANDSTONE,8); };
  g_calls["look_down"]=[]{ double yaw,p; player_look(g_player,yaw,p); set_look(yaw,-1.3); };
  g_calls["look_level"]=[]{ double yaw,p; player_look(g_player,yaw,p); set_look(yaw,-0.1); };
  g_calls["look_cow"]=[]{ double yaw,p; player_look(g_player,yaw,p); set_look(yaw,-0.25); };
  g_calls["hurt"]=[]{ player_set_health(g_player,2); };
  g_calls["full"]=[]{ player_set_health(g_player,20); };
  for(int s=1;s<=UI_SLOT_LAST;s++){ g_calls["slot"+std::to_string(s)]=[s]{ ui_click_slot(s,"click"); }; g_calls["rslot"+std::to_string(s)]=[s]{ ui_click_slot(s,"rclick"); }; }
  // Grid layouts, pushed in reverse so they run in order
  g_calls["grid_planks"]=[]{ place_in_grid(ITEM_OAK_LOG,1); };
  g_calls["grid_table"]=[]{ for(int g: {5,4,2,1}) place_in_grid(ITEM_PLANKS,g); };
  g_calls["grid_sticks"]=[]{ for(int g: {4,1}) place_in_grid(ITEM_PLANKS,g); };
  g_calls["grid_pickaxe"]=[]{ place_in_grid(ITEM_STICK,8); place_in_grid(ITEM_STICK,5); for(int g: {3,2,1}) place_in_grid(ITEM_PLANKS,g); };
  g_calls["grid_stone_pickaxe"]=[]{ place_in_grid(ITEM_STICK,8); place_in_grid(ITEM_STICK,5); for(int g: {3,2,1}) place_in_grid(ITEM_COBBLESTONE,g); };
  g_calls["output"]=[]{ ui_click_slot(50,"click"); };
  g_calls["select"]=[]{ };
  g_calls["aim_cow"]=[]{ int best=0; double bd=1e9; for(int c=1;c<=MAX_COWS;c++) if(cow_alive(g_cows,c)){ double x,y,z; cow_position(g_cows,c,x,y,z); double dx=x-px(),dz=z-pz(); double d=dx*dx+dz*dz; if(d<bd){bd=d;best=c;} }
     if(!best) return; double x,y,z; cow_position(g_cows,best,x,y,z); double dx=x-px(), dy=y+0.9-(py()+1.62), dz=z-pz(); set_look(wrap_angle(atan2(dz,dx)),atan2(dy,sqrt(dx*dx+dz*dz))); printf("[hook] aim cow %d dist %.2f\n",best,sqrt(bd)); };
  g_calls["cow_near"]=[]{ int c=cows_spawn(g_cows,g_random,px()+2.5,py()+0.2,pz()+0.8,2.3); record_set_real_at(g_cows,ATTR_TIMER,c,100.0); record_set_integer_at(g_cows,ATTR_COW_WALKING,c,0); printf("[hook] cow %d\n",c); };
  g_calls["clear_front"]=[]{ int x0=(int)px(),y0=(int)py(),z0=(int)pz(); for(int dx=1;dx<=5;dx++) for(int dz=-2;dz<=2;dz++) for(int dy=0;dy<=3;dy++) world_set_block(x0+dx,y0+dy,z0+dz,0); for(int dx=1;dx<=5;dx++) for(int dz=-2;dz<=2;dz++) world_set_block(x0+dx,y0-1,z0+dz,5); world_finish_maps(); mesh_reset(); };
  g_calls["give_furnace"]=[]{ inventory_add(g_inventory,11,1); inventory_add(g_inventory,9,6); for(int s=1;s<=9;s++) if(slot_item(g_inventory,s)==11) player_set_selected(g_player,s); };
  g_calls["aim_block_front"]=[]{ set_look(0,-0.55); };
  g_calls["aim_placed"]=[]{ set_look(0,-0.12); };
  g_calls["aim_furnace"]=[]{ set_look(0,-0.42); };
  g_calls["noclip_up"]=[]{ player_set_position(g_player,px(),py()+15,pz()); player_set_fall_peak(g_player,py()); player_set_velocity(g_player,0,0,0); };
  g_calls["time60"]=[]{ g_sim_time+=60; };
  g_calls["give_beef"]=[]{ inventory_add(g_inventory,ITEM_RAW_BEEF,3); };
  g_calls["give_cobble"]=[]{ inventory_add(g_inventory,ITEM_COBBLESTONE,5); };
  g_calls["to_water"]=[]{ for(int r=1;r<60;r++) for(int dx=-r;dx<=r;dx++) for(int dz=-r;dz<=r;dz++){ int x=(int)px()+dx, z=(int)pz()+dz; if(world_get_block(x,61,z)==8 && world_get_block(x,58,z)==8){ player_reset(g_player,x+0.5,60.5,z+0.5); set_look(0,-0.2); printf("[hook] water at %d %d\n",x,z); return; } } };
  g_calls["water_above"]=[]{ player_reset(g_player,px(),64.0,pz()-3.0); set_look(0.4,-0.55); printf("[hook] above the water at %.1f %.1f\n",px(),pz()); };
  g_calls["to_forest"]=[]{ int best=-1,bx=0,bz=0; for(int x=8;x<120;x+=2) for(int z=8;z<120;z+=2){ int n=0; for(int dx=-6;dx<=6;dx++) for(int dz=-6;dz<=6;dz++){ int t=world_top_solid_y(x+dx,z+dz); if(t>0&&world_get_block(x+dx,t,z+dz)==7) n++; } if(n>best){best=n;bx=x;bz=z;} }
     int t=world_top_solid_y(bx,bz); player_reset(g_player,bx+0.5,t+1.0,bz+0.5); set_look(0,0.05); printf("[hook] forest %d at %d %d\n",best,bx,bz); };
  g_calls["to_desert"]=[]{ for(int r=0;r<64;r++) for(int dx=-r;dx<=r;dx++) for(int dz=-r;dz<=r;dz++){ int x=64+dx,z=64+dz; if(world_biome(x,z)==BIOME_DESERT && world_biome(x+6,z)==BIOME_DESERT && world_biome(x-6,z)==BIOME_DESERT){ int t=world_top_solid_y(x,z); player_reset(g_player,x+0.5,t+1.0,z+0.5); set_look(0.6,-0.12); printf("[hook] desert at %d %d\n",x,z); return; } } printf("[hook] no desert\n"); };
  g_calls["to_meadow"]=[]{ int best=-1,bx=0,bz=0; for(int x=8;x<120;x+=2) for(int z=8;z<120;z+=2){ int n=0; for(int dx=-4;dx<=4;dx++) for(int dz=-4;dz<=4;dz++){ int t=world_top_solid_y(x+dx,z+dz); if(block_is_plant(world_get_block(x+dx,t+1,z+dz))) n++; } if(n>best){best=n;bx=x;bz=z;} }
     int t=world_top_solid_y(bx,bz); player_reset(g_player,bx+0.5,t+1.0,bz+0.5); set_look(0.3,-0.25); printf("[hook] meadow %d plants at %d %d\n",best,bx,bz); };
  g_calls["to_cave"]=[]{ for(int r=0;r<64;r++) for(int dx=-r;dx<=r;dx++) for(int dz=-r;dz<=r;dz++){ int x=64+dx,z=64+dz; if(!world_in_bounds(x,0,z)) continue; int top=world_top_solid_y(x,z); for(int y=10;y<top-6;y++){ if(world_get_block(x,y,z)==0&&world_get_block(x,y+1,z)==0&&world_get_block(x,y-1,z)!=0&&world_get_block(x+3,y,z)==0){ player_reset(g_player,x+0.5,y+0.01,z+0.5); set_look(0,-0.1); printf("[hook] cave at %d %d %d\n",x,y,z); return; } } } };
  g_calls["to_hill"]=[]{ int best=-1,bx=0,bz=0; for(int x=8;x<120;x+=3) for(int z=8;z<120;z+=3){ int t=world_top_solid_y(x,z); if(t>best){best=t;bx=x;bz=z;} } player_reset(g_player,bx+0.5,best+1.0,bz+0.5); set_look(0,-0.25); printf("[hook] hill %d at %d %d\n",best,bx,bz); };
  g_calls["house_view"]=[]{ int hx=record_integer(g_info,ATTR_HOUSE_X),hy=record_integer(g_info,ATTR_HOUSE_Y),hz=record_integer(g_info,ATTR_HOUSE_Z); player_reset(g_player,hx-4.5,hy+3.0,hz-5.0); set_look(0.75,-0.25); printf("[hook] house at %d %d %d\n",hx,hy,hz); };
  g_calls["stone_front"]=[]{ int x=(int)px()+2, y=(int)py(), z=(int)pz(); world_place_block(g_events,x,y,z,2); world_place_block(g_events,x,y+1,z,10); set_look(0,-0.3); };
  g_calls["select_pickaxe"]=[]{ int s=find_item(ITEM_WOODEN_PICKAXE); if(!s) s=find_item(ITEM_STONE_PICKAXE); if(s>0&&s<=9) player_set_selected(g_player,s); else printf("[hook] pickaxe not on hotbar (%d)\n",s); };
  for(auto pr: std::vector<std::pair<const char*,int>>{{"table",ITEM_CRAFTING_TABLE},{"pickaxe",ITEM_WOODEN_PICKAXE},{"stone_pickaxe",ITEM_STONE_PICKAXE},{"furnace",ITEM_FURNACE},{"cobble",ITEM_COBBLESTONE},{"sword",ITEM_STONE_SWORD},{"beef",ITEM_COOKED_BEEF},{"poppy",ITEM_POPPY},{"iron_pickaxe",ITEM_IRON_PICKAXE},{"iron_sword",ITEM_IRON_SWORD},{"door",ITEM_DOOR},{"bed",ITEM_BED}}){
    int item=pr.second; g_calls[std::string("hold_")+pr.first]=[item]{ int s=find_item(item); if(!s){ printf("[hook] no %s to hold\n",item_name(item).c_str()); return; }
      int i9=slot_item(g_inventory,9),c9=slot_count(g_inventory,9),d9=slot_damage(g_inventory,9);
      slot_set(g_inventory,9,item,slot_count(g_inventory,s),slot_damage(g_inventory,s)); if(s!=9) slot_set(g_inventory,s,i9,c9,d9); player_set_selected(g_player,9); }; }
  g_calls["aim_last_placed"]=[]{ if(g_edit_count<1) return; int cell=g_edit_index[g_edit_count]-1; int y=cell%WORLD_HEIGHT; cell/=WORLD_HEIGHT; int z=cell%WORLD_SIZE_Z, x=cell/WORLD_SIZE_Z;
     double dx=x+0.5-px(), dy=y+0.5-(py()+1.62), dz=z+0.5-pz(); set_look(wrap_angle(atan2(dz,dx)),atan2(dy,sqrt(dx*dx+dz*dz))); printf("[hook] aim at %d %d %d (block %d)\n",x,y,z,world_get_block(x,y,z)); };
  g_calls["stone_eye"]=[]{ int x=(int)px()-2, y=(int)py()+1, z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_STONE); set_look(PI,-0.15); printf("[hook] stone at %d %d %d\n",x,y,z); };
  g_calls["house_inside"]=[]{ int hx=record_integer(g_info,ATTR_HOUSE_X),hy=record_integer(g_info,ATTR_HOUSE_Y),hz=record_integer(g_info,ATTR_HOUSE_Z); player_reset(g_player,hx+3.5,hy+1.0,hz+1.6); set_look(PI/2,-0.2); printf("[hook] inside the house, light %d\n",world_get_light(hx+3,hy+2,hz+2)); };
  g_calls["chest_front"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); world_place_block(g_events,x,y,z,block_chest(FACING_PX,CHEST_SINGLE)); };
  g_calls["chests"]=[]{ for(int c=1;c<=MAX_CHESTS;c++) if(chest_used(g_furnaces,c)){ printf("[chest] %d at %d %d %d holds",c,record_integer_at(g_furnaces,ATTR_CHEST_X,c),record_integer_at(g_furnaces,ATTR_CHEST_Y,c),record_integer_at(g_furnaces,ATTR_CHEST_Z,c));
      for(int n=1;n<=CHEST_SLOTS;n++){ int sl=chest_slot(c,n); if(slot_item(g_furnaces,sl)) printf(" [%d]%s x%d",n,item_name(slot_item(g_furnaces,sl)).c_str(),slot_count(g_furnaces,sl)); } printf("\n"); } };
  g_calls["night"]=[]{ world_set_time_of_day(g_info,0.75); printf("[hook] time %s daylight %.2f night %d\n",world_clock_text(0.75).c_str(),world_daylight(0.75),world_is_night(0.75)); };
  g_calls["dusk"]=[]{ world_set_time_of_day(g_info,0.5); };
  g_calls["cow_turn"]=[]{ for(int c=1;c<=MAX_COWS;c++) if(cow_alive(g_cows,c)){ double y=cow_yaw(g_cows,c)+1.3; record_set_real_at(g_cows,ATTR_YAW,c,y); record_set_real_at(g_cows,ATTR_COW_GOAL_YAW,c,y); record_set_real_at(g_cows,ATTR_TIMER,c,100.0); } };
  g_calls["mobs_calm"]=[]{ for(int c=1;c<=MAX_COWS;c++) if(cow_alive(g_cows,c)){ record_set_real_at(g_cows,ATTR_MOB_ATTACK,c,100.0); record_set_real_at(g_cows,ATTR_COW_FLASH,c,0.0); } };
  g_calls["body"]=[]{ double y=0,p=0; player_look(g_player,y,p); printf("[hook] yaw %.2f body %.2f stride %.2f crouch %d\n",y,player_body_yaw(g_player),player_stride(g_player),player_crouching(g_player)); };
  g_calls["no_mobs"]=[]{ cows_clear(g_cows); };
  // key binds (33_key_binds): the held stack, drops lying about, crouching and sprinting
  g_calls["keys"]=[]{ int sl=player_selected(g_player); printf("[keys] slot %d %s x%d drops %d crouch %d sprint %d forward key %s jump key '%s'\n",
      sl,item_name(slot_item(g_inventory,sl)).c_str(),slot_count(g_inventory,sl),slots_count(SLOT_POOL_DROPS),player_crouching(g_player),
      player_sprinting(g_player),settings_bind(g_settings,BIND_FORWARD).c_str(),settings_bind(g_settings,BIND_JUMP).c_str()); };
  // the Nether (32_nether)
  g_calls["obsidian_frame"]=[]{ // an unlit frame 3 ahead (+x), across z, its inside 2 x 3 in front of the player; aim at its inside's floor
    int x0=(int)px(),y0=(int)py(),z0=(int)pz(); int fx=x0+3, fz=z0-1;
    for(int dx=1;dx<=5;dx++) for(int dz=-3;dz<=3;dz++){ for(int dy=0;dy<=6;dy++) world_set_block(x0+dx,y0+dy,z0+dz,0); world_set_block(x0+dx,y0-1,z0+dz,BLOCK_STONE); }
    world_finish_maps(); mesh_reset();
    for(int dz=0;dz<=3;dz++) for(int dy=0;dy<=4;dy++) if(dz==0||dz==3||dy==0||dy==4) world_place_block(g_events,fx,y0+dy,fz+dz,BLOCK_OBSIDIAN);
    double ex=px(),ey=py()+PLAYER_EYE_HEIGHT,ez=pz(); double tx=fx+0.5,ty=y0+1.0,tz=z0+0.5;
    double dx=tx-ex,dy=ty-ey,dz=tz-ez; set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz)));
    printf("[nether] frame at %d %d %d\n",fx,y0,fz); };
  g_calls["hold_flint_and_steel"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_FLINT_AND_STEEL,1,0); };
  g_calls["portals"]=[]{ int n=0,x0=(int)px(),z0=(int)pz(); for(int x=x0-12;x<=x0+12;x++) for(int z=z0-12;z<=z0+12;z++) for(int y=1;y<WORLD_HEIGHT-1;y++) if(world_get_block(x,y,z)==BLOCK_PORTAL) n++;
    printf("[nether] dimension %d portal blocks near %d  pos %.1f %.1f %.1f  standing on %d  feet %d  travel %d portal time %.2f health %d  wear %d\n",world_dimension(),n,px(),py(),pz(),
      world_get_block((int)px(),(int)(py()-0.1),(int)pz()),world_get_block((int)px(),(int)(py()+0.2),(int)pz()),player_wants_travel(g_player),player_portal_time(g_player),player_health(g_player),
      slot_damage(g_inventory,player_selected(g_player))); };
  g_calls["into_portal"]=[]{ int x,y,z; if(world_find_portal((int)px(),(int)py(),(int)pz(),8,x,y,z)){ player_set_position(g_player,x+0.5,y+0.01,z+0.5); printf("[nether] stepped into the portal at %d %d %d\n",x,y,z);} else printf("[nether] no portal near\n"); };
  g_calls["out_of_portal"]=[]{ player_set_position(g_player,px()-2.0,py(),pz()); };
  g_calls["nether_stats"]=[]{ int c[128]={0}; for(int x=0;x<WORLD_SIZE_X;x++) for(int z=0;z<WORLD_SIZE_Z;z++) for(int y=0;y<WORLD_HEIGHT;y++){ int b=world_get_block(x,y,z); if(b>=0&&b<128) c[b]++; }
    printf("[nether] dimension %d: netherrack %d lava %d soul sand %d glowstone %d quartz %d obsidian %d bedrock %d air %d stone %d\n",world_dimension(),c[BLOCK_NETHERRACK],c[BLOCK_LAVA],c[BLOCK_SOUL_SAND],c[BLOCK_GLOWSTONE],c[BLOCK_QUARTZ_ORE],c[BLOCK_OBSIDIAN],c[BLOCK_BEDROCK],c[BLOCK_AIR],c[BLOCK_STONE]); };
  g_calls["survival"]=[]{ player_set_game_mode(g_player,GAMEMODE_SURVIVAL); };
  g_calls["creative"]=[]{ player_set_game_mode(g_player,GAMEMODE_CREATIVE); };
  g_calls["into_lava"]=[]{ for(int x=4;x<WORLD_SIZE_X-4;x++) for(int z=4;z<WORLD_SIZE_Z-4;z++) if(world_get_block(x,NETHER_LAVA_LEVEL,z)==BLOCK_LAVA&&world_get_block(x,NETHER_LAVA_LEVEL+1,z)==BLOCK_AIR){ player_set_position(g_player,x+0.5,NETHER_LAVA_LEVEL+0.3,z+0.5); printf("[nether] into the lava at %d %d\n",x,z); return; } printf("[nether] no lava found\n"); };
  g_calls["back_to_portal"]=[]{ int x,y,z; if(world_find_portal(64,60,64,64,x,y,z)){ player_set_position(g_player,x+0.5,y+0.01,z-1.5); set_look(HALF_PI,-0.2); printf("[nether] beside the portal at %d %d %d\n",x,y,z);} };
  g_calls["break_frame"]=[]{ int x,y,z; if(world_find_portal((int)px(),(int)py(),(int)pz(),8,x,y,z)) world_break_block(g_events,x,y-1,z,ITEM_IRON_PICKAXE); };
  g_calls["nether_look"]=[]{ set_look(0.6,-0.05); };
  g_calls["nether_overlook"]=[]{ // the most open spot high over the lava sea, flying, looking out and a little down
    int best=-1,bx=64,bz=64,by=50; for(int x=16;x<112;x+=4) for(int z=16;z<112;z+=4) for(int y=44;y<=60;y+=4){ int n=0; for(int d=1;d<=24;d+=3) for(int a=0;a<4;a++){ int ax=x+(a==0?d:a==1?-d:0), az=z+(a==2?d:a==3?-d:0); if(world_get_block(ax,y,az)==BLOCK_AIR) n++; } if(world_get_block(x,y,z)==BLOCK_AIR&&n>best){best=n;bx=x;bz=z;by=y;} }
    player_set_flying(g_player,1); player_set_position(g_player,bx+0.5,by,bz+0.5); set_look(0.4,-0.35); printf("[nether] overlook at %d %d %d (%d open)\n",bx,by,bz,best); };
  // armour, the offhand and spawn eggs (31_armour_offhand_eggs)
  g_calls["give_armour"]=[]{ slot_set(g_inventory,19,ITEM_IRON_HELMET,1,0); slot_set(g_inventory,20,ITEM_IRON_CHESTPLATE,1,0); slot_set(g_inventory,21,ITEM_IRON_LEGGINGS,1,0);
    slot_set(g_inventory,22,ITEM_IRON_BOOTS,1,0); slot_set(g_inventory,23,ITEM_COW_SPAWN_EGG,2,0); slot_set(g_inventory,24,ITEM_TORCH,8,0); };
  g_calls["armour"]=[]{ printf("[armour] points %d health %d worn:",inventory_armour_points(g_inventory),player_health(g_player));
    for(int s=ARMOUR_SLOT_FIRST;s<=OFFHAND_SLOT;s++) printf(" [%d]%s x%d wear %d",s,item_name(slot_item(g_inventory,s)).c_str(),slot_count(g_inventory,s),slot_damage(g_inventory,s));
    printf("  cursor %s held %s\n",item_name(slot_item(g_inventory,0)).c_str(),item_name(player_held_item(g_player,g_inventory)).c_str()); };
  g_calls["zombie_hit"]=[]{ emit_event(g_events,EVT_ZOMBIE_ATTACK,ZOMBIE_DAMAGE,0,0,0,0.0,0.0,0.0,""); };
  g_calls["hold_egg"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_COW_SPAWN_EGG,2,0); };
  g_calls["hold_zombie_egg"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_ZOMBIE_SPAWN_EGG,1,0); };
  g_calls["hold_nothing"]=[]{ slot_clear(g_inventory,player_selected(g_player)); };
  g_calls["mobs"]=[]{ printf("[mobs] cows %d pigs %d zombies %d all %d\n",mobs_count_kind(g_cows,MOB_COW),mobs_count_kind(g_cows,MOB_PIG),mobs_count_kind(g_cows,MOB_ZOMBIE),cows_alive_count(g_cows)); };
  g_calls["target_above"]=[]{ int x,y,z; player_target_cell(g_player,x,y,z); printf("[hook] target %d %d %d block above %d\n",x,y,z,world_get_block(x,y+1,z)); };
  // the title screen's panorama: stand at (x, z) given by pano_at_<x>_<z>, 90 degree view, no HUD
  for(int k=0;k<8;k++) g_calls["pano_yaw"+std::to_string(k)]=[k]{ double y=0,p=0; player_look(g_player,y,p); set_look(k*PI/4.0,0.0); };
  g_calls["pano_setup"]=[]{ record_set_integer(g_settings,ATTR_SET_FOV,90); record_set_integer(g_settings,ATTR_SET_SHOW_HUD,0); record_set_integer(g_settings,ATTR_SET_RENDER_DISTANCE,RENDER_DISTANCE_MAX); record_set_integer(g_settings,ATTR_SET_DETAIL,DETAIL_HIGH); cows_clear(g_cows); world_set_time_of_day(g_info,0.30); };
  g_calls["pano_spot"]=[]{ const char*e=getenv("PANO_X"); int x=e?atoi(e):record_integer(g_info,ATTR_HOUSE_X)-6; e=getenv("PANO_Z"); int z=e?atoi(e):record_integer(g_info,ATTR_HOUSE_Z)-6; e=getenv("PANO_UP"); double up=e?atof(e):2.0; int t=world_top_solid_y(x,z); player_reset(g_player,x+0.5,t+up,z+0.5); player_set_game_mode(g_player,GAMEMODE_SPECTATOR); player_set_flying(g_player,1); printf("[hook] panorama at %d %d top %d\n",x,z,t); };
  g_calls["noon"]=[]{ world_set_time_of_day(g_info,0.25); };
  // diamonds, the jukebox and fire (34_diamonds_fire)
  g_calls["diamond_stats"]=[]{ int n=0,low=999,high=-1; for(int x=0;x<WORLD_SIZE_X;x++) for(int z=0;z<WORLD_SIZE_Z;z++) for(int y=0;y<WORLD_HEIGHT;y++) if(world_get_block(x,y,z)==BLOCK_DIAMOND_ORE){ n++; if(y<low) low=y; if(y>high) high=y; }
    printf("[diamond] diamond ore %d between y %d and %d\n",n,low,high); };
  g_calls["wear_diamond"]=[]{ slot_set(g_inventory,inventory_armour_slot(ARMOUR_HEAD),ITEM_DIAMOND_HELMET,1,0); slot_set(g_inventory,inventory_armour_slot(ARMOUR_CHEST),ITEM_DIAMOND_CHESTPLATE,1,0);
    slot_set(g_inventory,inventory_armour_slot(ARMOUR_LEGS),ITEM_DIAMOND_LEGGINGS,1,0); slot_set(g_inventory,inventory_armour_slot(ARMOUR_FEET),ITEM_IRON_BOOTS,1,0);
    slot_set(g_inventory,player_selected(g_player),ITEM_DIAMOND_SWORD,1,0); printf("[diamond] armour points %d\n",inventory_armour_points(g_inventory)); };
  g_calls["fire_hut"]=[]{ // a stone floor, a planks wall 3 ahead (+x) with a jukebox in it; aim at the floor in front of the wall
    int x0=(int)px(),y0=(int)py(),z0=(int)pz();
    for(int dx=1;dx<=6;dx++) for(int dz=-3;dz<=3;dz++){ for(int dy=0;dy<=4;dy++) world_set_block(x0+dx,y0+dy,z0+dz,0); world_set_block(x0+dx,y0-1,z0+dz,BLOCK_STONE); }
    world_finish_maps(); mesh_reset();
    for(int dz=-2;dz<=2;dz++) for(int dy=0;dy<=2;dy++) world_place_block(g_events,x0+4,y0+dy,z0+dz,(dz==0&&dy==0)?BLOCK_JUKEBOX:BLOCK_PLANKS);
    double ex=px(),ey=py()+PLAYER_EYE_HEIGHT,ez=pz(); double tx=x0+3.5,ty=y0-0.02,tz=z0+1.5;
    double dx=tx-ex,dy=ty-ey,dz=tz-ez; set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["fires"]=[]{ int f=0,pl=0,x0=(int)px(),y0=(int)py(),z0=(int)pz(); for(int x=x0-8;x<=x0+8;x++) for(int z=z0-8;z<=z0+8;z++) for(int y=y0-3;y<=y0+6;y++){ int b=world_get_block(x,y,z); if(b==BLOCK_FIRE) f++; if(b==BLOCK_PLANKS) pl++; }
    printf("[fire] fires %d planks %d health %d light at feet %d\n",f,pl,player_health(g_player),world_get_light(x0,y0,z0)); };
  g_calls["into_fire"]=[]{ int x0=(int)px(),y0=(int)py(),z0=(int)pz(); for(int x=x0-8;x<=x0+8;x++) for(int z=z0-8;z<=z0+8;z++) for(int y=y0-3;y<=y0+6;y++) if(world_get_block(x,y,z)==BLOCK_FIRE){ player_set_position(g_player,x+0.5,y+0.01,z+0.5); printf("[fire] standing in the fire at %d %d %d\n",x,y,z); return; } printf("[fire] no fire near\n"); };
  g_calls["look_up"]=[]{ double y=0,p=0; player_look(g_player,y,p); set_look(y,MAX_PITCH); };
  g_calls["head_left"]=[]{ double y=0,p=0; player_look(g_player,y,p); set_look(wrap_angle(y-0.5),0.0); printf("[hook] yaw %.2f body %.2f\n",wrap_angle(y-0.5),player_body_yaw(g_player)); };
  g_calls["head_right"]=[]{ double y=0,p=0; player_look(g_player,y,p); set_look(wrap_angle(y+0.5),0.0); printf("[hook] yaw %.2f body %.2f\n",wrap_angle(y+0.5),player_body_yaw(g_player)); };
  // each dimension's own chests (35_dimension_stores)
  g_calls["chest_behind"]=[]{ int x=(int)px()-2,y=(int)py(),z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_CHEST); printf("[stores] chest placed at %d %d %d in dimension %d\n",x,y,z,world_dimension()); };
  g_calls["fill_chest"]=[]{ int item=world_dimension()==DIM_NETHER?ITEM_NETHER_QUARTZ:ITEM_COAL; for(int c=1;c<=MAX_CHESTS;c++) if(chest_used(g_furnaces,c)&&slot_is_empty(g_furnaces,chest_slot(c,1))) slot_set(g_furnaces,chest_slot(c,1),item,world_dimension()==DIM_NETHER?7:5,0); };
  g_calls["away_chests"]=[]{ Attributes t; record_copy_unprefixed(g_away,t,AWAY_FURNACES); int n=0; printf("[stores] away:");
    for(int c=1;c<=MAX_CHESTS;c++) if(chest_used(t,c)){ n++; printf(" chest %d at %d %d %d holds %s x%d;",c,record_integer_at(t,ATTR_CHEST_X,c),record_integer_at(t,ATTR_CHEST_Y,c),record_integer_at(t,ATTR_CHEST_Z,c),item_name(slot_item(t,chest_slot(c,1))).c_str(),slot_count(t,chest_slot(c,1))); }
    Attributes m; record_copy_unprefixed(g_away,m,AWAY_COWS); int mobs=0; for(int k=1;k<=MAX_COWS;k++) if(record_integer_at(m,ATTR_USED,k)==1) mobs++;
    printf(" %d chests, %d mobs (dimension %d now)\n",n,mobs,world_dimension()); };
  g_calls["write_legacy_world"]=[]{ FILE*f=fopen("cubeland_worlds/Legacy.cubeworld","w"); if(!f){ printf("[stores] can't write\n"); return; }
    fprintf(f,"CUBELAND_WORLD 2\ndimension 0\nseed 4242\n");
    fprintf(f,"rec furnaces chest_used_1 i 1\nrec furnaces chest_x_1 i 10\nrec furnaces chest_y_1 i 40\nrec furnaces chest_z_1 i 10\nrec furnaces chest_dim_1 i 1\n");
    fprintf(f,"rec furnaces item_%d i %d\nrec furnaces count_%d i 9\n",CHEST_SLOT_BASE+1,ITEM_GLOWSTONE,CHEST_SLOT_BASE+1);
    fprintf(f,"rec furnaces chest_used_2 i 1\nrec furnaces chest_x_2 i 64\nrec furnaces chest_y_2 i 70\nrec furnaces chest_z_2 i 64\nrec furnaces chest_dim_2 i 0\n");
    fprintf(f,"rec furnaces item_%d i %d\nrec furnaces count_%d i 3\n",CHEST_SLOT_BASE+CHEST_SLOTS+1,ITEM_STICK,CHEST_SLOT_BASE+CHEST_SLOTS+1);
    fprintf(f,"rec cows used_1 i 1\nrec cows kind_1 i %d\nrec cows x_1 r 10.5\nrec cows y_1 r 40\nrec cows z_1 r 10.5\nrec cows dim_1 i 1\n",MOB_PIG);
    fprintf(f,"edits 100 1\nother_edits 200 %d\nend\n",BLOCK_GLOWSTONE); fclose(f); printf("[stores] wrote a version 2 world\n"); };
  g_calls["world_files"]=[]{ if(system("cd cubeland_worlds && find Stores Legacy Legacy.cubeworld -type f | sort | sed 's/^/[stores] file /'; head -c 40 Legacy.cubeworld | sed 's/^/[stores] old file: /'; echo")){} };
  g_calls["light_fire_here"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); printf("[fire] lit %d\n",world_light_fire(g_events,x,y,z)); };
  g_calls["shared_cells"]=[]{ printf("[hook] host broke 87 67 63: %d; bob placed 86 68 63: %d and 86 69 63: %d\n",world_get_block(87,67,63),world_get_block(86,68,63),world_get_block(86,69,63)); };
  g_calls["clock"]=[]{ double t=world_time_of_day(g_info); printf("[hook] clock %s (%.3f) day %d daylight %.2f\n",world_clock_text(t).c_str(),t,record_integer(g_info,ATTR_WORLD_DAYS),world_daylight(t)); };
  g_calls["give_night_kit"]=[]{ inventory_add(g_inventory,ITEM_TORCH,16); inventory_add(g_inventory,ITEM_GLASS,8); inventory_add(g_inventory,ITEM_BED,1); inventory_add(g_inventory,ITEM_IRON_SWORD,1); };
  g_calls["torch_ahead"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); if(world_get_block(x,y,z)!=0||!world_is_solid(x,y-1,z)){ y=world_top_solid_y(x,z)+1; } world_place_block(g_events,x,y,z,BLOCK_TORCH); printf("[hook] torch at %d %d %d: light here %d, 1 away %d, 5 away %d, 14 away %d, light steps %d\n",x,y,z,world_get_light(x,y,z),world_get_light(x,y+1,z),world_get_light(x,y+5,z),world_get_light(x,y+14,z),g_light_steps); };
  g_calls["torch_light_check"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); int lit=0; for(int dx=-15;dx<=15;dx++) for(int dy=-15;dy<=15;dy++) for(int dz=-15;dz<=15;dz++) if(world_get_light(x+dx,y+dy,z+dz)>0) lit++; printf("[hook] lit cells near the torch: %d\n",lit); };
  g_calls["zombie_front"]=[]{ int c=mobs_spawn(g_cows,g_random,MOB_ZOMBIE,px()+4.5,py()+0.01,pz(),PI); set_look(0,-0.1); printf("[hook] zombie %d\n",c); };
  g_calls["mobs"]=[]{ printf("[hook] cows %d pigs %d zombies %d\n",mobs_count_kind(g_cows,MOB_COW),mobs_count_kind(g_cows,MOB_PIG),mobs_count_kind(g_cows,MOB_ZOMBIE)); };
  g_calls["pig_near"]=[]{ int c=mobs_spawn(g_cows,g_random,MOB_PIG,px()+2.5,py()+0.2,pz()+0.8,2.3); record_set_real_at(g_cows,ATTR_TIMER,c,100.0); record_set_integer_at(g_cows,ATTR_COW_WALKING,c,0); printf("[hook] pig %d\n",c); };
  // Items on the ground, by item
  g_calls["drop_items"]=[]{ printf("[hook] drops:"); for(int d=1;d<=MAX_DROPS;d++) if(drop_used(g_drops,d)) printf(" %s x%d",item_name(drop_item(g_drops,d)).c_str(),drop_count(g_drops,d)); printf("\n"); };
  g_calls["glass_wall"]=[]{ int x=(int)px()+3,y=(int)py(),z=(int)pz(); for(int dz=-1;dz<=1;dz++) for(int dy=0;dy<=2;dy++) world_place_block(g_events,x,y+dy,z+dz,BLOCK_GLASS); set_look(0,0.1); };
  g_calls["bed_front"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_BED); set_look(0,-0.5); printf("[hook] bed at %d %d %d\n",x,y,z); };
  g_calls["spawn_point"]=[]{ printf("[hook] spawn %.1f %.1f %.1f\n",record_real(g_info,ATTR_SPAWN_X),record_real(g_info,ATTR_SPAWN_Y),record_real(g_info,ATTR_SPAWN_Z)); };
  g_calls["planks_eye"]=[]{ int x=(int)px()-2, y=(int)py()+1, z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_PLANKS); set_look(PI,-0.15); };
  g_calls["iron_eye"]=[]{ int x=(int)px()-2, y=(int)py()+1, z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_IRON_ORE); set_look(PI,-0.15); printf("[hook] iron ore at %d %d %d\n",x,y,z); };
  g_calls["iron_recipes"]=[]{ // lay each iron tool out in the 3 x 3 grid and ask the recipe book
    struct R{ const char*rows; int out; }; R rs[]={{"AAA.B..B.",ITEM_IRON_PICKAXE},{"AA.AB..B.",ITEM_IRON_AXE},{".A..B..B.",ITEM_IRON_SHOVEL},{".A..A..B.",ITEM_IRON_SWORD}};
    for(auto&r:rs){ grid_clear(g_grid,3); for(int k=0;k<9;k++){ int it=r.rows[k]=='A'?ITEM_IRON_INGOT:(r.rows[k]=='B'?ITEM_STICK:0); if(it) slot_set(g_grid,k+1,it,1,0); }
      int m=crafting_match(g_book,g_grid); printf("[recipe] %s -> %s (%s)\n",r.rows,m>0?item_name(record_integer_at(g_book,ATTR_RECIPE_OUTPUT,m)).c_str():"nothing",(m>0&&record_integer_at(g_book,ATTR_RECIPE_OUTPUT,m)==r.out)?"ok":"WRONG"); }
    grid_clear(g_grid,2);
    printf("[recipe] iron ore smelts into %s\n",item_name(item_smelt_result(ITEM_IRON_ORE)).c_str()); };
  g_calls["block_below_target"]=[]{ int x,y,z; player_target_cell(g_player,x,y,z); printf("[hook] target block %s, selected slot %d holds %s\n",item_name(world_get_block(x,y,z)).c_str(),player_selected(g_player),item_name(player_held_item(g_player,g_inventory)).c_str()); };
  g_calls["cover"]=[]{ printf("[hook] cover"); int st=getenv("COVER_ALL")?1:20; for(int c=1;c<=g_cover_columns;c+=st){ printf(" "); for(int k=1;k<=g_cover_count[c];k++) printf("%s%.0f..%.0f",k>1?",":"",g_cover_low[(c-1)*COVER_SPANS+k]<-1e29?-1:g_cover_low[(c-1)*COVER_SPANS+k],g_cover_high[(c-1)*COVER_SPANS+k]>1e29?9999:g_cover_high[(c-1)*COVER_SPANS+k]); } printf("\n"); };
  // A row of plants two blocks ahead (+x) of the player, standing on flat ground
  // ---- doors, beds, crouching (scenario 22): a flat 13 x 13 floor around the player, who faces +x
  g_calls["flat_area"]=[]{ int x0=(int)floor(px())+20, y0=(int)floor(py()), z0=(int)floor(pz());
     if(y0<20) y0=64; s_ox=x0; s_oy=y0; s_oz=z0;  // 20 blocks from the spawn point, clear of the house
     for(int dx=-6;dx<=6;dx++) for(int dz=-6;dz<=6;dz++){ for(int dy=-3;dy<0;dy++) world_set_block(x0+dx,y0+dy,z0+dz,BLOCK_STONE); world_set_block(x0+dx,y0-1,z0+dz,BLOCK_GRASS); for(int dy=0;dy<6;dy++) world_set_block(x0+dx,y0+dy,z0+dz,BLOCK_AIR); }
     for(int dx=-6;dx<=6;dx++) for(int dz=-6;dz<=6;dz++) for(int dy=-3;dy<6;dy++) mesh_mark_dirty(x0+dx,y0+dy,z0+dz);
     for(int dx=-7;dx<=7;dx++) for(int dz=-7;dz<=7;dz++) world_update_column_top(x0+dx,z0+dz);
     player_reset(g_player,x0+0.5,y0+0.01,z0+0.5); set_look(0.0,-0.3); cows_clear(g_cows);
     printf("[hook] flat area at %d %d %d\n",x0,y0,z0); };
  // chests: placed by the player beside each other, they join; the
  // cells, the open screen and breaking one half
  g_calls["hold_chests"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_CHEST,4,0); };
  g_calls["aim_ground_2z1"]=[]{ double dx=s_ox+2.5-px(), dy=s_oy-0.02-player_eye_y(g_player), dz=s_oz+1.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["aim_chest"]=[]{ double dx=s_ox+2.5-px(), dy=s_oy+0.5-player_eye_y(g_player), dz=s_oz+0.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["chest_cells"]=[]{ for(int dz=-1;dz<=2;dz++){ int b=world_get_block(s_ox+2,s_oy,s_oz+dz);
       if(block_is_chest(b)) printf("[chest] cell z%+d block %d facing %d type %d\n",dz,b,block_chest_facing(b),block_chest_type(b)); else printf("[chest] cell z%+d block %d\n",dz,b); }
     printf("[chest] screen %d chest %d chest2 %d\n",ui_screen(g_ui),record_integer(g_ui,ATTR_UI_CHEST),record_integer(g_ui,ATTR_UI_CHEST2)); };
  g_calls["fill_chests"]=[]{ int n=0; for(int c=1;c<=MAX_CHESTS;c++) if(chest_used(g_furnaces,c)){ n++; slot_set(g_furnaces,chest_slot(c,1+n),n==1?ITEM_COAL:ITEM_DIAMOND,n*3,0); } };
  g_calls["break_chest_half"]=[]{ world_break_block(g_events,s_ox+2,s_oy,s_oz+1,ITEM_NONE); };
  g_calls["view_chests"]=[]{ player_reset(g_player,s_ox+0.3,s_oy+0.01,s_oz-1.6); double dx=s_ox+2.5-px(), dy=s_oy+0.2-player_eye_y(g_player), dz=s_oz+0.3-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["view_chests_back"]=[]{ player_reset(g_player,s_ox+4.6,s_oy+0.01,s_oz+3.0); double dx=s_ox+2.5-px(), dy=s_oy+0.2-player_eye_y(g_player), dz=s_oz+0.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["hold_pickaxe"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_DIAMOND_PICKAXE,1,0); };
  g_calls["hold_sword"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_IRON_SWORD,1,0); };
  g_calls["give_bed"]=[]{ slot_set(g_inventory,player_selected(g_player),ITEM_BED,1,0); };
  g_calls["give_door_bed"]=[]{ inventory_add(g_inventory,ITEM_DOOR,2); inventory_add(g_inventory,ITEM_BED,1); };
  g_calls["aim_ground_2"]=[]{ double dx=s_ox+2.5-px(), dy=s_oy-0.02-player_eye_y(g_player), dz=s_oz+0.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["aim_ground_side"]=[]{ double dx=s_ox+1.5-px(), dy=s_oy-0.02-player_eye_y(g_player), dz=s_oz-1.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["aim_door"]=[]{ double dx=s_ox+2.9-px(), dy=s_oy+1.0-player_eye_y(g_player), dz=s_oz+0.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["aim_open_door"]=[]{ double dx=s_ox+2.5-px(), dy=s_oy+1.0-player_eye_y(g_player), dz=s_oz+0.9-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["view_door_edge"]=[]{ player_position(g_player,s_saved_x,s_saved_y,s_saved_z); player_reset(g_player,s_ox+1.2,s_oy+0.01,s_oz+1.9); double dx=s_ox+2.9-px(), dy=s_oy+1.0-player_eye_y(g_player), dz=s_oz+0.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["aim_bed_head"]=[]{ double dx=s_ox+1.5-px(), dy=s_oy+0.3-player_eye_y(g_player), dz=s_oz-2.5-pz(); set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); };
  g_calls["cells"]=[]{ printf("[hook] door cells %d %d   bed cells %d %d %d %d (beside: %d %d)\n",
       world_get_block(s_ox+2,s_oy,s_oz),world_get_block(s_ox+2,s_oy+1,s_oz),
       world_get_block(s_ox+1,s_oy,s_oz-2),world_get_block(s_ox+1,s_oy,s_oz-3),world_get_block(s_ox+2,s_oy,s_oz-2),world_get_block(s_ox+2,s_oy,s_oz-3),
       world_get_block(s_ox+1,s_oy,s_oz-1),world_get_block(s_ox+2,s_oy,s_oz-1));
     int drops=0, beds=0; for(int d=1;d<=MAX_DROPS;d++) if(drop_used(g_drops,d)){ drops++; if(drop_item(g_drops,d)==ITEM_BED) beds++; }
     printf("[hook] player at %.2f %.2f %.2f eye %.2f crouching %d flying %d; drops %d (beds %d)\n",px(),py(),pz(),player_eye_y(g_player)-py(),player_crouching(g_player),player_flying(g_player),drops,beds); };
  g_calls["face_x"]=[]{ player_reset(g_player,s_ox+0.5,s_oy+0.01,s_oz+0.5); set_look(0.0,0.0); };
  g_calls["hole_ahead"]=[]{ for(int dz=-1;dz<=1;dz++) for(int dy=-3;dy<0;dy++){ world_set_block(s_ox+3,s_oy+dy,s_oz+dz,BLOCK_AIR); mesh_mark_dirty(s_ox+3,s_oy+dy,s_oz+dz); world_update_column_top(s_ox+3,s_oz+dz); }
     player_reset(g_player,s_ox+0.5,s_oy+0.01,s_oz+0.5); set_look(0.0,0.0); };
  g_calls["clear_test_blocks"]=[]{ for(int dx=1;dx<=3;dx++) for(int dz=-3;dz<=0;dz++) for(int dy=0;dy<3;dy++){ world_set_block(s_ox+dx,s_oy+dy,s_oz+dz,BLOCK_AIR); mesh_mark_dirty(s_ox+dx,s_oy+dy,s_oz+dz); } };
  g_calls["aim_poppy"]=[]{ double x,y,z; player_position(g_player,x,y,z); int bx=(int)floor(x)+3, by=(int)floor(y), bz=(int)floor(z);
     double ex=x, ey=player_eye_y(g_player), ez=z;
     double tz[2]={bz+0.5,bz+0.08};
     for(int i=0;i<2;i++){ double dx=bx+0.5-ex, dy=by+0.3-ey, dz=tz[i]-ez; set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); player_update_target(g_player,g_cows);
       int cx,cy,cz; player_target_cell(g_player,cx,cy,cz); printf("[hook] aim at poppy %s: kind %d cell %d %d %d block %d\n",i?"cell edge":"middle",player_target_kind(g_player),cx,cy,cz,world_get_block(cx,cy,cz)); }
     set_look(0.12,-0.35); };
  g_calls["restore_pos"]=[]{ player_reset(g_player,s_saved_x,s_saved_y,s_saved_z); set_look(0.12,-0.35); };
  g_calls["aim_torch"]=[]{ double x,y,z; player_position(g_player,x,y,z); s_saved_x=x; s_saved_y=y; s_saved_z=z; player_reset(g_player,x+2.0,y,z-1.0); int bx=(int)floor(x)+5, by=(int)floor(y), bz=(int)floor(z); x+=2.0; z-=1.0;
     double dx=bx+0.5-x, dy=by+0.4-player_eye_y(g_player), dz=bz+0.5-z; set_look(atan2(dz,dx),atan2(dy,sqrt(dx*dx+dz*dz))); player_update_target(g_player,g_cows); int cx,cy,cz; player_target_cell(g_player,cx,cy,cz); printf("[hook] aim at torch: kind %d cell %d %d %d block %d\n",player_target_kind(g_player),cx,cy,cz,world_get_block(cx,cy,cz)); };
  g_calls["plant_row"]=[]{ double x,y,z; player_position(g_player,x,y,z); int px=(int)floor(x)+3, py=(int)floor(y), pz=(int)floor(z);
     int kinds[4]={BLOCK_TALL_GRASS,BLOCK_POPPY,BLOCK_DANDELION,BLOCK_DEAD_BUSH};
     for(int dz=-3;dz<=4;dz++) for(int dx=-1;dx<=4;dx++){ world_set_block(px+dx,py-1,pz+dz,BLOCK_GRASS); for(int dy=0;dy<4;dy++) world_set_block(px+dx,py+dy,pz+dz,BLOCK_AIR); mesh_mark_dirty(px+dx,py,pz+dz); mesh_mark_dirty(px+dx,py-1,pz+dz); }
     for(int k=0;k<4;k++){ world_set_block(px,py,pz-1+k,kinds[k]); mesh_mark_dirty(px,py,pz-1+k); }
     world_set_block(px+2,py,pz,BLOCK_TORCH); mesh_mark_dirty(px+2,py,pz);
     printf("[hook] plants at x %d, z %d..%d, y %d; torch at x %d\n",px,pz-1,pz+2,py,px+2);
     set_look(0.12,-0.35); };
  g_calls["font"]=[]{ extern Text g_text_font; printf("[hook] font setting \"%s\", drawn with \"%s\"\n",settings_font(g_settings).c_str(),g_text_font.c_str()); };
  // The furnace placed last: its block and the brightest block light next to it
  g_calls["furnace_light"]=[]{ for(int e=g_edit_count;e>=1;e--){ int cell=g_edit_index[e]-1; int y=cell%WORLD_HEIGHT; cell/=WORLD_HEIGHT; int z=cell%WORLD_SIZE_Z, x=cell/WORLD_SIZE_Z;
       int b=world_get_block(x,y,z); if(!block_is_furnace(b)) continue; int best=0; for(int d=0;d<6;d++){ int dx=d==0?1:d==1?-1:0, dy=d==2?1:d==3?-1:0, dz=d==4?1:d==5?-1:0; best=std::max(best,world_get_light(x+dx,y+dy,z+dz)); }
       printf("[hook] furnace at %d %d %d block %d lit %d light beside it %d\n",x,y,z,b,block_furnace_is_lit(b),best); return; } printf("[hook] no furnace placed\n"); };
  g_calls["render_stats"]=[]{ printf("[hook] render: %s\n",render_stats_text().c_str()); };
  g_calls["frame_stats"]=[]{ printf("[hook] frame stats: %s\n",hud_frame_stats(g_hud).c_str()); };
  g_calls["give_planks_far"]=[]{ slot_set(g_inventory,20,ITEM_PLANKS,7,0); };
  g_calls["settings"]=[]{ printf("[settings] view %d detail %d plants %d shading %d fov %d mouse %d jump %d hud %d\n",settings_render_distance(g_settings),settings_detail(g_settings),
     settings_flag(g_settings,ATTR_SET_PLANTS),settings_flag(g_settings,ATTR_SET_SHADING),settings_fov_degrees(g_settings),record_integer(g_settings,ATTR_SET_SENSITIVITY),settings_flag(g_settings,ATTR_SET_AUTO_JUMP),settings_flag(g_settings,ATTR_SET_SHOW_HUD)); };
  g_calls["overflow"]=[]{ for(int s=1;s<=NUM_SECTIONS;s++) if(g_section_state[s]==SECTION_BUILT && g_section_count[s]>=SECTION_FACE_CAP){ int sy=(s-1)%SECTIONS_Y, r=(s-1)/SECTIONS_Y, sz=r%SECTIONS_Z, sx=r/SECTIONS_Z; int plants=0,leaves=0,air=0;
       for(int x=sx*16;x<sx*16+16;x++) for(int z=sz*16;z<sz*16+16;z++) for(int y=sy*16;y<sy*16+16;y++){ int b=world_get_block(x,y,z); if(block_is_plant(b)) plants++; if(b==BLOCK_LEAVES) leaves++; if(b==0) air++; }
       printf("[overflow] section %d %d %d full: plants %d leaves %d air %d\n",sx,sy,sz,plants,leaves,air); } };
  g_calls["section_max"]=[]{ int best=0,built=0; for(int s=1;s<=NUM_SECTIONS;s++){ if(g_section_state[s]!=SECTION_BUILT) continue; built++; if(g_section_count[s]>best) best=g_section_count[s]; } printf("[sections] built %d, most faces %d (cap %d), overflow %d\n",built,best,SECTION_FACE_CAP,g_mesh_overflow); };
  g_calls["build_all"]=[]{ for(int sx=0;sx<SECTIONS_X;sx++) for(int sy=0;sy<SECTIONS_Y;sy++) for(int sz=0;sz<SECTIONS_Z;sz++) mesh_ensure_section(sx,sy,sz); };
  g_calls["select_empty"]=[]{ for(int s=1;s<=9;s++) if(slot_is_empty(g_inventory,s)){ player_set_selected(g_player,s); return; } };
  g_calls["terrain_stats"]=[]{ int biomes[6]={0}; int plants=0,cactus=0,coal=0,caves=0,water_high=0; double rough=0; int n=0;
     for(int x=0;x<WORLD_SIZE_X;x++) for(int z=0;z<WORLD_SIZE_Z;z++){ biomes[world_biome(x,z)]++; int t=g_height_map[world_column(x,z)]; if(x>0){ rough+=abs(t-g_height_map[world_column(x-1,z)]); n++; }
       for(int y=1;y<WORLD_HEIGHT;y++){ int b=world_get_block(x,y,z); if(block_is_plant(b)) plants++; if(b==BLOCK_CACTUS) cactus++; if(b==BLOCK_COAL_ORE) coal++; if(b==0&&y<t-3) caves++; if(b==BLOCK_WATER&&y>=SEA_LEVEL) water_high++; } }
     printf("[terrain] plains %d forest %d desert %d beach %d ocean %d  plants %d cactus %d coal %d cave cells %d pond water %d  mean slope %.3f\n",biomes[1],biomes[2],biomes[3],biomes[4],biomes[5],plants,cactus,coal,caves,water_high,rough/n); };
  g_calls["records"]=[]{ int n; Get_number_of_attributes(g_player,n); printf("[records] player %d fields, ",n); Get_number_of_attributes(g_cows,n); printf("cows %d, ",n); Get_number_of_attributes(g_drops,n); printf("drops %d, ",n); Get_number_of_attributes(g_inventory,n); printf("inventory %d, ",n); Get_number_of_attributes(g_settings,n); printf("settings %d\n",n); };

  // ---------------- multiplayer: a made-up second player "bob" writes his log by hand
  // (in whichever folder the game uses: the shared folder, or a LAN helper's)
  auto bob_path=[]{ return fix_path(record_text(g_net,"folder"))+"/log_"+record_text(g_net,"session")+"_bob_77.txt"; };
  auto bob_write=[bob_path](const Text&t){ FILE*f=fopen(bob_path().c_str(),"a"); if(!f){ printf("[net] bob can't write %s\n",bob_path().c_str()); return; } fputs(t.c_str(),f); fclose(f); };
  g_calls["bob_join"]=[bob_write]{ char b[256]; snprintf(b,256,"J bob ~\nP %.2f %.2f %.2f 3.1416 0.2 ~\nC hello from bob ~\n",px()+5.5,py(),pz()+0.5); bob_write(b); };
  g_calls["bob_walk"]=[bob_write]{ char b[256]; snprintf(b,256,"P %.2f %.2f %.2f 3.1416 -0.3 ~\n",px()+5.5,py(),pz()-0.8); bob_write(b); };
  g_calls["bob_place"]=[bob_write]{ char b[256]; snprintf(b,256,"B %d %d %d %d ~\n",(int)floor(px())+2,(int)floor(py()),(int)floor(pz()),BLOCK_PLANKS); bob_write(b); };
  g_calls["bob_half"]=[bob_write]{ char b[256]; snprintf(b,256,"B %d %d %d %d",(int)floor(px())+2,(int)floor(py())+1,(int)floor(pz()),BLOCK_STONE); bob_write(b); };
  g_calls["bob_finish"]=[bob_write]{ bob_write(" ~\n"); };
  g_calls["bob_time"]=[bob_write]{ bob_write("T 0.75 ~\n"); };
  g_calls["bob_leave"]=[bob_write]{ bob_write("L ~\n"); };
  g_calls["bob_whisper"]=[bob_write]{ bob_write("W "+record_text(g_net,"name")+" psst, just you ~\nW somebody_else not for you ~\n"); };
  g_calls["lan_files"]=[]{ int n=0; Dynamic_Text names; List_files_in_folder("cubeland_worlds/mp","lan_*.txt",n,names);
     for(auto&f:names.items){ FILE*fp=fopen(("cubeland_worlds/mp/"+f).c_str(),"r"); char line[256]; Text all; while(fp&&fgets(line,256,fp)){ Text t=line; if(!t.empty()&&t.back()=='\n') t.pop_back(); all+=t+" | "; } if(fp) fclose(fp); printf("[lan] %s: %s\n",f.c_str(),all.c_str()); }
     printf("[lan] net mode %d, cheats %d, guest mode %d, hud says open %d\n",net_mode(g_net),net_cheats(g_net),record_integer(g_net,"guest_mode"),record_integer(g_hud,"lan")); };
  // the host is still playing on another computer: mark its LAN world open again
  g_calls["reopen_lan"]=[]{ int n=0; Dynamic_Text names; List_files_in_folder("cubeland_worlds/mp","lan_*.txt",n,names);
     for(auto&f:names.items){ Text p="cubeland_worlds/mp/"+f; FILE*fp=fopen(p.c_str(),"r"); char line[256]; Text all; while(fp&&fgets(line,256,fp)){ Text t=line; if(t.compare(0,5,"open ")==0) t="open 1\n"; all+=t; } if(fp) fclose(fp); fp=fopen(p.c_str(),"w"); fputs(all.c_str(),fp); fclose(fp); } };
  // ---------------------------------------------------------------- the LAN helper (simulated in harness.cpp)
  g_calls["lan_firewall"]=[]{ extern bool g_lan_firewall; g_lan_firewall=true; };
  g_calls["lan_no_powershell"]=[]{ extern bool g_lan_no_powershell; g_lan_no_powershell=true; };
  g_calls["lan_fixed"]=[]{ extern bool g_lan_firewall; extern bool g_lan_no_powershell; g_lan_firewall=false; g_lan_no_powershell=false; };
  // every helper folder and what its status and control files say
  g_calls["lan_dirs"]=[]{ DIR*d=opendir("cubeland_worlds/lan"); if(!d){ printf("[lan] no helper folder\n"); return; } std::vector<Text> v; while(auto e=readdir(d)){ Text n=e->d_name; if(n[0]!='.') v.push_back(n);} closedir(d); std::sort(v.begin(),v.end());
     for(auto&n:v){ printf("[lan] %s:",n.c_str()); int c=0; Dynamic_Text names; List_files_in_folder("cubeland_worlds/lan/"+n,"*.txt",c,names);
       for(auto&f:names.items){ printf(" %s",f.c_str()); if(f.compare(0,7,"status_")==0||f.compare(0,8,"control_")==0){ std::ifstream in("cubeland_worlds/lan/"+n+"/"+f); Text l; std::getline(in,l); printf(" (%s)",l.c_str()); } } printf("\n"); } };
  // "another PC" hosts the world this PC just hosted: its folder copied to run/remote, open again
  g_calls["remote_host"]=[]{ DIR*d=opendir("cubeland_worlds/lan"); Text last; while(d&&true){ auto e=readdir(d); if(!e) break; Text n=e->d_name; if(n.compare(0,2,"h_")==0&&n>last) last=n; } if(d) closedir(d);
     if(last.empty()){ printf("[lan] no hosted world to copy\n"); return; }
     mkdir("remote",0755); Text to="remote/"+last; mkdir(to.c_str(),0755); int c=0; Dynamic_Text names; List_files_in_folder("cubeland_worlds/lan/"+last,"*.txt",c,names);
     for(auto&f:names.items){ if(f.compare(0,7,"status_")==0||f.compare(0,8,"control_")==0) continue; std::ifstream in("cubeland_worlds/lan/"+last+"/"+f,std::ios::binary); std::stringstream ss; ss<<in.rdbuf(); Text t=ss.str();
       if(f.compare(0,4,"lan_")==0){ size_t p=t.find("\nopen 0"); if(p!=Text::npos) t.replace(p,7,"\nopen 1"); } std::ofstream out(to+"/"+f,std::ios::binary); out<<t; }
     printf("[lan] the other PC hosts %s\n",last.c_str()); };
  // bob, on the other PC, says something in the remote world; then that host quits
  g_calls["remote_bob"]=[]{ DIR*d=opendir("remote"); while(d){ auto e=readdir(d); if(!e) break; Text n=e->d_name; if(n.compare(0,2,"h_")!=0) continue; Text s=n.substr(2);
       std::ofstream("remote/"+n+"/log_"+s+"_bob_77.txt",std::ios::app)<<"C hello over the network ~\n"; } if(d) closedir(d); };
  g_calls["remote_close"]=[]{ DIR*d=opendir("remote"); while(d){ auto e=readdir(d); if(!e) break; Text n=e->d_name; if(n.compare(0,2,"h_")!=0) continue; Text s=n.substr(2), p="remote/"+n+"/lan_"+s+".txt";
       std::ifstream in(p); std::stringstream ss; ss<<in.rdbuf(); Text t=ss.str(); size_t at=t.find("\nopen 1"); if(at!=Text::npos) t.replace(at,7,"\nopen 0"); in.close(); std::ofstream(p)<<t; } if(d) closedir(d); };
  g_calls["lan_list"]=[]{ printf("[lan] listed %d:",record_integer(g_lan,"count")); for(int i=1;i<=record_integer(g_lan,"count");i++) printf(" [%s - %s, mode %d, cheats %d]",record_text_at(g_lan,"host",i).c_str(),record_text_at(g_lan,"world",i).c_str(),record_integer_at(g_lan,"mode",i),record_integer_at(g_lan,"cheats",i)); printf("\n"); };
  g_calls["try_cheat"]=[]{ printf("[lan] /time set day: %s\n",command_run("/time set day",g_info,g_player,g_inventory,g_net,g_peers).c_str()); printf("[lan] /w bob hi: %s\n",command_run("/w bob hi there",g_info,g_player,g_inventory,g_net,g_peers).c_str()); };
  g_calls["net"]=[]{
     int x=(int)floor(px())+2, y=(int)floor(py()), z=(int)floor(pz());
     printf("[net] mode %d players: %s; cells ahead %d %d\n",net_mode(g_net),net_players_text(g_net,g_peers,g_sim_time).c_str(),world_get_block(x,y,z),world_get_block(x,y+1,z));
     for(int p=1;p<=peers_count(g_peers);p++){ double a,b,c; peer_position(g_peers,p,a,b,c); printf("[net] peer %d %s here %d at %.2f %.2f %.2f offset %d\n",p,peer_name(g_peers,p).c_str(),peer_here(g_peers,p),a,b,c,record_integer_at(g_peers,"offset",p)); }
     Text mine=fix_path(record_text(g_net,"folder"))+"/log_"+record_text(g_net,"session")+"_"+record_text(g_net,"id")+".txt";
     FILE*f=fopen(mine.c_str(),"r"); int n=0; char line[512]; std::map<char,int> tags; Text last;
     if(f){ while(fgets(line,512,f)){ n++; tags[line[0]]++; if(line[0]=='B') last=line; } fclose(f); }
     printf("[net] my log: %d lines (J %d P %d H %d B %d C %d T %d L %d) last block line: %s",n,tags['J'],tags['P'],tags['H'],tags['B'],tags['C'],tags['T'],tags['L'],last.empty()?"none\n":last.c_str()); };
  g_calls["break_ahead"]=[]{ int x=(int)floor(px())+3, y=(int)floor(py())-1, z=(int)floor(pz()); world_break_block(g_events,x,y,z,0); printf("[hook] broke %d %d %d\n",x,y,z); };
  g_calls["ground_ahead"]=[]{ int x=(int)floor(px())+3, y=(int)floor(py())-1, z=(int)floor(pz()); printf("[hook] ground ahead %d %d %d is %d\n",x,y,z,world_get_block(x,y,z)); };
}
