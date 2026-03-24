
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
select surf_pocket1, protein and id [18,478,511,513,515,503,481,483,953,426,427,429,430,428,431,432,433,434,435,448,875,903,908,906,907,923,447,465,464,411,412,413,415,143,405,8,9,11,12,510,7,28,535,538,531,528,529,530,963,521,522,960,928,970,30,888,889,890,910,911,475,338,340,358] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [60,62,63,65,15,23,1058,13,1063,1060,81,82,77,78,85,98,1045,1065,102,103,120,118,83,76,20,24,25,533,539,541,532,968,525,543,1038,1041,1042,1043,998,1023,978,988,989,990,985,986,987,415,408,410,128,136,137,130,129,3,138,417,418,420] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [169,171,172,173,175,186,187,189,191,168,333,167,335,336,337,338,353,348,314,315,316,317,318,320,328,313,245,263,293,215,223,222,224,226,225,203,211,227,243,244,246,247,228,190,205,170] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [660,662,666,671,690,696,697,720,672,673,675,715,717,719,726,727,698,625,763,760,627,728,655,659,661,663] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        