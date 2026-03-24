
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
        
        load "data/structure_089.rebuilt.pdb", protein
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
 
        load "data/structure_089.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [20,23,543,977,978,74,75,76,77,78,79,80,81,91,92,93,94,95,96,30,540,533,1059,1060,1045,1061,1062,1066,1067,1068,1043,97,3,10,12,13,98,518,33,32,61,593,56,598,594,62,63,64,66,67,70,73,35,34,36,575,577,40,595,38,590,88,990,993,980,983,986,988,998,1008,1023,1006,1020,1036,1037,1038,1039,1040,973,1009,1010,1026,1027,1028,683,573,411,408] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [18,953,908,433,462,885,888,463,905,907,410,15,513,506,509,510,511,413,429,431,432,143,435,521,522,526,528,960,963,928,25,478,477,479,503,481,338,339,341,342,343,460,466,467,358,340] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [79,80,81,82,90,95,20,13,98,83,102,103,99,101,138,411,416,417,418,414,130,135,403,402,405,406,407,408,128] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [323,458,460,452,454,456,473,474,320,338,318,335,341,322,342,343,325,476,477,438,437,439,440,436,441,442,444,431,432,451] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [401,404,405,383,410,15,510,141,142,409,143,358] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        