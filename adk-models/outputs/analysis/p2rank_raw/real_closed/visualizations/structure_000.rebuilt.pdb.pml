
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
        
        load "data/structure_000.rebuilt.pdb", protein
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
 
        load "data/structure_000.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [61,62,63,65,23,67,68,533,523,1063,79,80,82,101,96,97,98,99,100,118,81,83,70,20,22,531,21,411,13,145,416,418,144,147,148,141,138,130,408,128,3,146,59,60,78,58,93,1025,1027,1043,1044,1045,1041,1042,1060,1064,55,543,988,539,540,978,968,970,1023,987,981,983,985,1038] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [435,430,528,953,923,907,908,422,424,425,888,889,903,890,905,25,18,405,410,512,513,420,421,27,28,538,963,891,892,429,427,428,434,436,438,431,432,433,458,460,462,463,465,478,464,295,317,318,319,321,322,301,302,299,300,143,153,338,413,403,511,505,151,152,155,337,340,358,356,357,333,335,336,320] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [57,58,73,668,666,56,50,52,553,595,593,594,574,575,576,592,573,1000,989,990,992,683,658,48] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [877,879,878,853,880,891,892,893,31,32,28,33,538,34,35,36,37,42,41,425,435,873,874,876,875,888,889,890] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [716,725,727,731,733,698,660,763,618,663,665,673,712,713,710,693,696,655,653,621,626,762,628,728] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [293,243,296,298,300,313,314,315,316,317,318,154,155,171,156,157,172,173,153,228,230,333] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        