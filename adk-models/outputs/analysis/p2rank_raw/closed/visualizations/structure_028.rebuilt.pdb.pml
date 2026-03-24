
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
        
        load "data/structure_028.rebuilt.pdb", protein
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
 
        load "data/structure_028.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1043,1025,1041,1042,1039,1040,1058,1060,1045,57,60,78,543,988,978,539,541,540,542,977,975,55,58,1038,1020,1022,990,1023,998,987,985,981,983,984,986,15,20,22,23,24,533,13,1063,523,525,62,63,65,25,103,80,96,97,98,100,101,102,118,79,81,82,83,85,30,31,534,535,33,417,418,415,408,10,138,129,128,5,420] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [16,17,18,512,513,953,510,420,425,426,428,427,429,413,431,432,433,435,447,448,903,905,907,923,924,925,405,145,411,412,415,888,27,28,534,535,538,526,527,528,530,928,963,908,927,926,890,910,887,21,24,521,524,25,430,478,476,463,465,459,461,462,460,503,143,338,340,322,323] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [728,736,727,729,731,733,734,725,726,719,724,660,763,663,720,688,696,697,701,698,642,653,656,641,738,638,628] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [150,143,353,337,338,356,153,168,430,333,334,335,336,320,426,427,429,413,145,412,146,149,151] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [188,191,193,333,334,335,336,223,315,317,225,313,243,168,169,170,172,173,175,263] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [260,262,263,318,293,153,172,173,174,175,176,177,243,245,315,317,313,188,191,193,333] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [51,580,563,578,577,53,551,552,553,554,555,52,543,546,559,560,561,562,37,38,46,41,42,43,833,820,836,837,838,853] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [31,32,28,538,34,35,36,37,38,53,551,552,553,554,555,543,546,547] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        