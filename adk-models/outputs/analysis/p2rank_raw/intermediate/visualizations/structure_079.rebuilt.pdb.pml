
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
        
        load "data/structure_079.rebuilt.pdb", protein
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
 
        load "data/structure_079.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [18,412,413,429,430,431,508,509,510,511,513,953,151,420,421,422,424,152,153,425,427,428,434,433,463,923,903,905,436,142,143,410,403,146,25,29,21,24,26,27,28,528,529,530,970,873,32,34,35,888,538,890,963,907,908,911,910,874,876,877,875,887,891,892,893,895,904,906,913,334,333,155,168,335,336,337,338,339,340,353,358,503,173,169,170,171,315,225,228,243,323,460,478,466,505,318,458,317,319,320,321,322,314] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [3,13,1042,1043,1045,1058,1059,1061,1062,1063,523,63,65,58,61,62,76,78,33,545,533,541,543,965,968,23,20,21,22,535,960,54,55,40,45,53,1023,1020,1025,1038,1039,1041,987,989,990,985,998,978,981,988,80,1066,100,95,96,97,98,118,81,82,83,73,77,1027,1030,408,14,15,414,415] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [620,660,663,696,738,698,733,762,765,715,720,728,741,651,653,655,626,628,645,618] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [37,38,41,42,43,837,853,578,820,833,836,838,817,818,840,46,48,562,563,565] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        