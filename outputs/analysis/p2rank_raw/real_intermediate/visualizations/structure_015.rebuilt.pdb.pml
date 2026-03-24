
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
        
        load "data/structure_015.rebuilt.pdb", protein
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
 
        load "data/structure_015.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [533,13,520,523,1043,1058,1063,58,62,63,66,22,23,543,978,536,539,540,541,968,970,531,532,534,960,535,1045,78,79,81,80,97,98,99,100,118,82,83,1020,1021,1022,1023,1025,1038,1041,1019,986,987,981,984,985,983,137,411,408,409,128,3,145,138,141,15,10,414,418,415] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.278,0.702]
select surf_pocket2, protein and id [152,153,413,428,18,8,505,502,480,504,150,156,157,158,155,383,403,385,143,427,429,431,432,433,458,460,462,478,425,438,295,320,338,340,342,503,356,353,354,358,318,322,477] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.576,0.361,0.902]
select surf_pocket3, protein and id [430,432,433,462,463,465,464,478,953,948,923,903,18,510,513,428,528,955,28,538,888,889,890,891,904,906,907,908,910] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.616,0.278,0.702]
select surf_pocket4, protein and id [653,654,655,618,620,660,760,763,726,727,728,663,696,698,733,731,710,716,724,725,712,693,713] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.792]
select surf_pocket5, protein and id [315,333,228,320,337,338,171,172,173,243,227,316,313,317,318,152,153,160,155,168] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.447]
select surf_pocket6, protein and id [37,38,41,42,43,578,598,580,582,833,834,835,836,819,820,565,818,837,838,563,853,581] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.361]
select surf_pocket7, protein and id [874,876,877,875,855,873,852,853,854,856,31,32,34,35,36,28,29,33,37,38,39,41] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.447,0.278]
select surf_pocket8, protein and id [31,35,24,25,27,40,42,63,64,65,66,23,67,418,417,421,422,426,430] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.792,0.361]
select surf_pocket9, protein and id [425,436,437,438,430,429,433,441,442,421,422,424,426,872,875,888,873,31,35,28] 
set surface_color,  pcol9, surf_pocket9 
   
        
        deselect
        
        orient
        