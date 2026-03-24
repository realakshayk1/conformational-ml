
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
        
        load "data/structure_023.rebuilt.pdb", protein
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
 
        load "data/structure_023.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [533,978,1043,1058,1060,1062,1063,523,58,59,62,63,64,60,65,78,55,988,23,31,33,35,541,979,968,543,986,981,982,1023,1038,80,85,98,94,96,97,1024,1025,118,95,79,81,82,83,1022,414,416,15,411,21,13,14,6,11,518,418,417,420,138,128,408,3,145] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.616,0.278,0.702]
select surf_pocket2, protein and id [414,415,15,18,411,413,409,152,153,149,151,143,403,404,410,405,428,430,431,432,433,435,465,510,462,463,464,28,528,25,27,908,333,336,337,338,340,505,503,504,170,173,322,325,477,478,323,321,318,319,356,357,358,168] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.361]
select surf_pocket3, protein and id [222,224,225,238,223,241,242,172,173,243,328,329,330,332,333,293,315,313,312,188,226] 
set surface_color,  pcol3, surf_pocket3 
   
        
        deselect
        
        orient
        