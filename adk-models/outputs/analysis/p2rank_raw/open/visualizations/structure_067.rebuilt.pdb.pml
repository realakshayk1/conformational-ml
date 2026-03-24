
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
        
        load "data/structure_067.rebuilt.pdb", protein
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
 
        load "data/structure_067.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [425,427,153,412,18,413,8,511,513,428,429,430,431,432,434,435,436,437,458,433,439,462,463,888,411,143,403,404,397,398,401,405,19,20,527,873,28,528,908,891,318,321,333,322,337,338,341,505,503,504,152,173,168,154,339,340,353,354,355,356,357,358,155,325,343,457,293,460,473,474,475,476,477,478,323] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [1043,1025,1039,1041,1042,1045,1058,60,78,540,541,975,976,977,978,981,543,542,988,990,986,987,1022,1023,1038,23,533,65,80,1063,79,82] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [101,80,85,93,95,97,98,1063,118,79,82,83,15,533,13,23,65,408,410,3,138,128,418,1043,1045,78] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [673,618,719,720,721,696,716,717,698,724,725,726,727,731,697,662,663,669,672,670,690,692,693,653,654,655,626,628,728,622,619,620,763] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [46,48,837,838,578,38,554,555,817,818,819,820,821,822,598,562,565,579,580,581,582,583,833,835,37,39,41,853,43,790] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [528,529,530,907,908,28,538,891,892,524,525,527,19,20,435,433,463,888,903,905,18,513] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [173,263,318,333,155,170,172,175,223,315,313,225,226,227,188,228,243,295,293,292] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        