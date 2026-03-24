
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
        
        load "data/structure_004.rebuilt.pdb", protein
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
 
        load "data/structure_004.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [25,420,31,19,20,21,24,26,27,46,35,32,33,34,36,547,548,28,30,538,892,893,527,528,529,530,908,953,963,37,41,43,834,853,835,38,48,53,837,838,555,833,872,873,876,888,895,903,904,905,906,907,923,852,855,422,423,424,425,428,430,431,432,153,415,433,18,478,515,510,513,503,435,436,437,439,440,462,463,460,465,144,145,146,405,412,413,414,8,7,151,149,150,133,143,403,383,395,398,386,477,500,337,338,340,358,353,354,356,357,360] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [78,79,81,80,93,1042,1043,1045,1063,62,418,65,82,83,408,3,13,96,98,85,543,533,978,980,968,970,63,35,60,25,31,23,523,525,1023,1024,1025,987,988,33,406,410,130,136,128] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [627,759,760,618,761,762,763,727,728,755,628,655,665,721,724,725,717,698,663] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [291,292,293,239,240,258,238,313,316,317,318,314,315,173,333,225,241,242,243] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        