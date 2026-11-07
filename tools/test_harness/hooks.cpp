// Test hooks appended to the translated macro (they can see its globals and functions)
extern std::map<Text,std::function<void()>> g_calls;
extern int g_box_w, g_box_h;
void push_front_click(const char*kind,double x,double y);
static double px(){ double x,y,z; player_position(g_player,x,y,z); return x; }
static double py(){ double x,y,z; player_position(g_player,x,y,z); return y; }
static double pz(){ double x,y,z; player_position(g_player,x,y,z); return z; }
static double s_saved_x=0,s_saved_y=0,s_saved_z=0;
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
static void register_hooks(){
  g_calls["dump"]=dump;
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
  for(auto pr: std::vector<std::pair<const char*,int>>{{"table",ITEM_CRAFTING_TABLE},{"pickaxe",ITEM_WOODEN_PICKAXE},{"stone_pickaxe",ITEM_STONE_PICKAXE},{"furnace",ITEM_FURNACE},{"cobble",ITEM_COBBLESTONE},{"sword",ITEM_STONE_SWORD},{"beef",ITEM_COOKED_BEEF},{"poppy",ITEM_POPPY},{"iron_pickaxe",ITEM_IRON_PICKAXE},{"iron_sword",ITEM_IRON_SWORD}}){
    int item=pr.second; g_calls[std::string("hold_")+pr.first]=[item]{ int s=find_item(item); if(!s){ printf("[hook] no %s to hold\n",item_name(item).c_str()); return; }
      int i9=slot_item(g_inventory,9),c9=slot_count(g_inventory,9),d9=slot_damage(g_inventory,9);
      slot_set(g_inventory,9,item,slot_count(g_inventory,s),slot_damage(g_inventory,s)); if(s!=9) slot_set(g_inventory,s,i9,c9,d9); player_set_selected(g_player,9); }; }
  g_calls["aim_last_placed"]=[]{ if(g_edit_count<1) return; int cell=g_edit_index[g_edit_count]-1; int y=cell%WORLD_HEIGHT; cell/=WORLD_HEIGHT; int z=cell%WORLD_SIZE_Z, x=cell/WORLD_SIZE_Z;
     double dx=x+0.5-px(), dy=y+0.5-(py()+1.62), dz=z+0.5-pz(); set_look(wrap_angle(atan2(dz,dx)),atan2(dy,sqrt(dx*dx+dz*dz))); printf("[hook] aim at %d %d %d (block %d)\n",x,y,z,world_get_block(x,y,z)); };
  g_calls["stone_eye"]=[]{ int x=(int)px()-2, y=(int)py()+1, z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_STONE); set_look(PI,-0.15); printf("[hook] stone at %d %d %d\n",x,y,z); };
  g_calls["house_inside"]=[]{ int hx=record_integer(g_info,ATTR_HOUSE_X),hy=record_integer(g_info,ATTR_HOUSE_Y),hz=record_integer(g_info,ATTR_HOUSE_Z); player_reset(g_player,hx+3.5,hy+1.0,hz+1.6); set_look(PI/2,-0.2); printf("[hook] inside the house, light %d\n",world_get_light(hx+3,hy+2,hz+2)); };
  g_calls["chest_front"]=[]{ int x=(int)px()+2,y=(int)py(),z=(int)pz(); world_place_block(g_events,x,y,z,BLOCK_CHEST); };
  g_calls["chests"]=[]{ for(int c=1;c<=MAX_CHESTS;c++) if(chest_used(g_furnaces,c)){ printf("[chest] %d at %d %d %d holds",c,record_integer_at(g_furnaces,ATTR_CHEST_X,c),record_integer_at(g_furnaces,ATTR_CHEST_Y,c),record_integer_at(g_furnaces,ATTR_CHEST_Z,c));
      for(int n=1;n<=CHEST_SLOTS;n++){ int sl=chest_slot(c,n); if(slot_item(g_furnaces,sl)) printf(" [%d]%s x%d",n,item_name(slot_item(g_furnaces,sl)).c_str(),slot_count(g_furnaces,sl)); } printf("\n"); } };
  g_calls["night"]=[]{ world_set_time_of_day(g_info,0.75); printf("[hook] time %s daylight %.2f night %d\n",world_clock_text(0.75).c_str(),world_daylight(0.75),world_is_night(0.75)); };
  g_calls["dusk"]=[]{ world_set_time_of_day(g_info,0.5); };
  g_calls["cow_turn"]=[]{ for(int c=1;c<=MAX_COWS;c++) if(cow_alive(g_cows,c)){ double y=cow_yaw(g_cows,c)+1.3; record_set_real_at(g_cows,ATTR_YAW,c,y); record_set_real_at(g_cows,ATTR_COW_GOAL_YAW,c,y); record_set_real_at(g_cows,ATTR_TIMER,c,100.0); } };
  g_calls["mobs_calm"]=[]{ for(int c=1;c<=MAX_COWS;c++) if(cow_alive(g_cows,c)){ record_set_real_at(g_cows,ATTR_MOB_ATTACK,c,100.0); record_set_real_at(g_cows,ATTR_COW_FLASH,c,0.0); } };
  g_calls["noon"]=[]{ world_set_time_of_day(g_info,0.25); };
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
}
