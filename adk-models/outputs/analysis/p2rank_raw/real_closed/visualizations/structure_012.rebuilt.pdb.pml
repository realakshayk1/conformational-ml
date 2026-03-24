
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
        
        load "data/structure_012.rebuilt.pdb", protein
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
 
        load "data/structure_012.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [58,543,78,79,80,93,968,1058,1043,1044,1045,1062,1063,1042,1046,1047,970,541,542,979,539,540,1022,1025,1027,1038,1030,1023,981,985,978,535,525,533,534,523,13,3,97,98,100,118,113,404,405,407,128,65,82,83,94,96,411,141,145,408,410,138,137,22,23,414,415,418,62,148] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [422,424,426,427,428,431,434,436,423,953,528,963,27,28,31,35,429,430,432,433,460,507,508,478,504,505,465,320,325,15,18,511,513,515,403,25,413,153,338,339,341,342,343,340,506,358,538,875,888,435,873,908,890,892,906,923,904,905,907,903,437,463,462,438] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [334,336,337,338,339,341,342,343,335,340,353,503,358,385,150,155,171,172,173,168,228,333,413,142,143,144,145,11,15,513,8,401,405,403,149,151,152,153,146,320,317,318,314,315,316,293,243,313,427,428] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [42,43,37,41,44,45,46,47,48,579,580,578,598,581,582,38,833,853,836,837,838,561,562,563,565,817,818,820] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [50,73,661,662,664,665,666,668,594,595,613,596,597,57,59,60,688,66,68,658,620] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [731,733,736,728,698,725,727,618,660,663,763,715,738,628,655,626,627,653] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [50,73,58,56,57,60,74,76,77,78,75,1000,1006,1007,1023,1008,990] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [26,27,29,30,35,42,43,39,40,45,422,423,25,421,63] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        