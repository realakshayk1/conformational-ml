
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
select surf_pocket1, protein and id [22,23,31,32,33,542,543,536,537,538,539,79,80,81,82,83,92,93,72,74,75,77,78,95,96,97,4,98,1057,12,13,19,20,408,533,524,1058,531,526,2,3,1063,1059,1061,1062,523,1039,1041,1042,1043,1022,1036,1028,1037,975,1038,1046,1047,1048,978,987,988,981,983,984,985,986,996,977,545,553,551,998,999,1006,1007,1009,1010,1021,100,112,113,56,59,61,34,45,593,36,40,990,573,575,577,67,62,73,683,1000,411,130,415,5,11,404,1,421,138] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [513,515,953,478,951,888,904,908,905,463,923,430,436,437,18,433,432,434,435,445,870,880,882,528,526,883,889,890,524,525,959,954,956,957,911,25,27,481,466,467,468,462] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [167,171,172,173,243,185,188,225,228,338,331,333,334,321,322,323,326,316,317,318,315,328,314,420,428,150,152,425,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [143,17,413,429,431,440,18,433,432,434,435,513,478,460,462,477,337,339,341,338,325,335,323] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [31,543,538,853,551,577,578,38,34,35,593,36,573,575] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [68,65,682,57,61,597,598,58,613,679,680,665,599,609,610,600,661] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [620,761,762,763,727,717,721,724,726,715,663,668,695,666,670,618] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [142,402,406,410,143,413,8,401,404,405,358,340,357,383,385] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        