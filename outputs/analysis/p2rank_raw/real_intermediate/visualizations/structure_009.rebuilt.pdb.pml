
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
        
        load "data/structure_009.rebuilt.pdb", protein
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
 
        load "data/structure_009.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [288,424,425,427,429,430,431,436,438,428,433,461,462,463,464,950,465,437,439,441,442,444,446,447,450,459,460,478,480,466,28,528,907,908,953,923,31,34,41,35,853,32,36,39,40,27,29,875,888,889,891,892,890,904,905,906,903,872,873,870,851,852,850,15,18,413,505,511,512,513,422,423,143,403,11,8,385,337,338,340,343,503,353,354,356,357,383,358,25,421,42,63,45,44] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [79,80,81,82,83,97,98,1062,1063,408,3,118,68,1025,1043,1045,418,66,21,22,23,535,13,523,958,58,543,533,541,1060,968,62,63,59,61,60,978,1059,985,138,409,410,405,10,128,145,148,411,415] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [618,619,621,763,655,663,762,673,692,712,713,716,624,696,733,698,700,731,725,710,653,727,760,728] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [320,333,334,338,335,172,173,168,171,170,188,228,152,153,155,315,317,318] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [288,425,430,434,435,438,291,318,301,302,458,293,294,295,296,153,155,158,320] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [41,43,38,578,833,817,820,836,580,837,838,563,48,597,598,596] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [172,173,333,228,230,155,242,243,292,293,310,313,315,317,318,314] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        