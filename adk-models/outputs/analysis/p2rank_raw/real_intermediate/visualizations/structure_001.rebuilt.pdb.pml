
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
        
        load "data/structure_001.rebuilt.pdb", protein
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
 
        load "data/structure_001.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [60,62,65,78,56,58,523,1063,81,79,82,80,96,97,98,100,118,93,94,113,83,23,533,536,537,539,540,541,968,29,31,33,35,543,30,1043,1025,1027,1042,1006,1007,987,990,1000,978,985,1023,988,408,409,410,13,10,3,128,418,138] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [18,430,431,432,19,20,513,953,954,508,510,478,425,428,429,28,534,535,538,973,528,529,530,963,970,955,875,888,889,890,891,892,893,904,905,907,908,928,910,923,924,926,927,870,872,873,850,903,441,433,462,463,464,465,445,439] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [18,430,431,432,505,503,478,151,152,153,428,143,383,403,149,150,15,413,337,353,339,340,341,342,356,358,357,318,320,338,325,434,435,433,458,459,460] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [660,663,664,665,618,763,765,716,693,696,712,713,671,672,733,727,728,725,731,755,726,698,610,673,626,628,621,760,762,653,655] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [873,876,852,853,856,875,877,835,31,32,34,35,36,28,37,41,38,422,424,425,429,430,431] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [432,503,478,428,318,319,320,321,338,322,323,325,475,339,340,341,434,435,458,460,302,303,305] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [790,833,598,817,41,42,43,46,38,580,578,834,836,837,820,835,853] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        