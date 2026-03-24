
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
        
        load "data/structure_097.rebuilt.pdb", protein
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
 
        load "data/structure_097.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1043,1058,1060,1042,1044,1045,1063,1046,58,60,78,80,543,542,540,978,968,33,55,1023,1024,1025,1026,1039,1041,1005,986,987,988,1000,1038,1040,979,980,13,23,98,97,100,118,62,83,82,418,408,404,405,10,128,3,26,532,533,535,525,523,30] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [151,153,142,143,144,145,168,133,403,383,385,155,333,334,336,337,338,335,353,339,340,341,342,343,358,357,355,173,169,170,171,172,317,319,320,321,322,323,325,460,477,478,505,503,318,141,412,413,401,15,18,427,428,431,433] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [18,529,513,953,526,527,528,28,429,430,428,431,433,413,478,460,462,463,465,923,904,905,906,907,920,908] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [18,531,534,535,529,530,528,28,430,31,32,536,537,541,538,870,873,889,890,891,892,893,908,888,435] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [724,729,731,733,726,717,721,725,696,698,711,712,716,663,670,763,618,620,622,653,655,762,727,728,627,628,626] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [62,63,83,82,23,418,35,25,421,422,27,29,30,31,24,26,533,535,58,60,78,80,543,542,540,33,55] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [100,115,116,117,118,13,98,1,2,3,10,4,6,1063,1062,1066,1067] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        