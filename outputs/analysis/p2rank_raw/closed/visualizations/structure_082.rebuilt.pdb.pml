
        from pymol import cmd,stored
        
        set depth_cue, 1
        set fog_start, 0.4
        
        set_color b_col, [36,36,85]
        set_color t_col, [10,10,10]
        set bg_rgb_bottom, b_col
        set bg_rgb_top, t_col      
        set bg_gradient
        
        set  spec_power  =  200
        set  spec_refl   =  0
        
        load "data/structure_082.rebuilt.pdb", protein
        create ligands, protein and organic
        select xlig, protein and organic
        delete xlig
        
        hide everything, all
        
        color white, elem c
        color bluewhite, protein
        #show_as cartoon, protein
        show surface, protein
        #set transparency, 0.15
        
        show sticks, ligands
        set stick_color, magenta
        
        
        
        
        # SAS points
 
        load "data/structure_082.rebuilt.pdb_points.pdb.gz", points
        hide nonbonded, points
        show nb_spheres, points
        set sphere_scale, 0.2, points
        cmd.spectrum("b", "green_red", selection="points", minimum=0, maximum=0.7)
        
        
        stored.list=[]
        cmd.iterate("(resn STP)","stored.list.append(resi)")    # read info about residues STP
        lastSTP=stored.list[-1] # get the index of the last residue
        hide lines, resn STP
        
        cmd.select("rest", "resn STP and resi 0")
        
        for my_index in range(1,int(lastSTP)+1): cmd.select("pocket"+str(my_index), "resn STP and resi "+str(my_index))
        for my_index in range(1,int(lastSTP)+1): cmd.show("spheres","pocket"+str(my_index))
        for my_index in range(1,int(lastSTP)+1): cmd.set("sphere_scale","0.4","pocket"+str(my_index))
        for my_index in range(1,int(lastSTP)+1): cmd.set("sphere_transparency","0.1","pocket"+str(my_index))
        
        
        
        set_color pcol1 = [0.361,0.576,0.902]
select surf_pocket1, protein and id [98,1063,1045,1059,1061,530,13,536,1058,533,1060,63,65,77,78,80,82,83,23,33,543,97,99,100,95,94,96,1025,1023,1042,1043,406,407,408,5,135,417,416,419,420,400,118] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.278,0.702]
select surf_pocket2, protein and id [888,905,908,923,903,478,465,953,511,513,514,515,521,480,510,956,435,444,445,463,448,883,885,18,433,438,437,441,526,528,963,892,893,966,522,959,960,962,28,479] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.576,0.361,0.902]
select surf_pocket3, protein and id [348,351,168,332,333,334,336,337,338,329,330,331,316,317,320,360,367,368,365,203,328,224,225,226,185,186,187,188,243,258,227,230,200,169,170,172,173,292,293,150] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.616,0.278,0.702]
select surf_pocket4, protein and id [11,409,412,414,432,14,15,17,411,430,433,410,8,440,463,512,513,480,510,478,143,142,341,458,460,477,503,340,358,339,338] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.792]
select surf_pocket5, protein and id [62,64,69,71,66,67,68,61,60,56,57,613,54,55,73,657,658,688,58,683,684,685,686,687] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.447]
select surf_pocket6, protein and id [426,428,143,431,436,150,153,432,433,440,317,318,320,322,323,332,334,335,336,337,338,341,325,458,460,340,358,339,173] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.361]
select surf_pocket7, protein and id [551,553,593,984,985,544,978,981,982,545,549,573,991,993,575,585,60,598,595,540,543,63] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.447,0.278]
select surf_pocket8, protein and id [850,867,868,871,438,437,439,441,435,442,444,445,874,448,883,885,875] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.792,0.361]
select surf_pocket9, protein and id [667,669,717,718,721,692,693,696,618,668,764,765,761,663,666] 
set surface_color,  pcol9, surf_pocket9 
   
        
        deselect
        
        orient
        