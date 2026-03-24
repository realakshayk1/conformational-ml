
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
        
        load "data/structure_058.rebuilt.pdb", protein
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
 
        load "data/structure_058.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [62,65,78,63,23,533,978,523,1058,1059,1060,1043,1061,80,85,90,97,98,99,100,101,102,1062,1063,1065,1025,1045,76,79,81,82,83,58,73,55,535,966,970,968,543,541,987,989,990,981,985,1023,1022,1024,1005,988,127,131,135,408,410,103,126,3,118,128,10,13] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [339,340,358,357,383,386,390,353,359,360,337,338,505,502,503,504,15,18,413,8,510,509,511,513,150,151,153,147,149,405,403,401,397,143,428] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [662,666,669,670,671,673,696,733,698,627,655,626,618,663,628,760,762,717,719,720,712,716,725,726,727,731,753,755,728,610] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [834,835,836,837,838,841,853,854,855,856,858,41,43,833,46,48,578,38,39,40,553,555,560,562,563,820] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [525,25,430,428,433,18,21,413,415,513,24,28,527,528,505,478] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [318,319,320,321,322,323,503,460,478,338,339,340,341,342,343,428,431,432,433,458,151,153,413,152] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [852,853,854,855,856,873,874,876,877,878,37,38,31,34,35,36,28,41] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [261,262,263,291,293,174,175,315,318,313,317,173,243,241,242,264,265,279,280] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        