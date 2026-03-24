
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
        
        load "data/structure_027.rebuilt.pdb", protein
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
 
        load "data/structure_027.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [30,542,543,546,535,537,541,978,532,533,19,20,21,23,25,531,525,524,32,33,54,56,593,52,40,78,1043,1060,1061,1042,1058,1062,1063,12,13,408,15,10,3,67,68,58,59,60,61,63,34,36,53,538,549,989,982,990,993,551,553,555,560,1024,1025,1026,1038,1041,1039,1040,988,1023,79,77,98,95,81,83,1010,412,414,407,411,417,418,416,420,138,406,5] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [437,415,430,433,434,435,513,952,953,922,923,511,948,420,422,438,439,441,446,447,463,444,462,888,905,907,908,440,31,855,889,890,962,963,878,881,883,886,891,892,893,873,875,27,29,18,16,26,28,528,530,525,960,478,465,480,483] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [337,338,150,165,172,153,173,332,333,336,334,320,168,143,425,427,431,144,145,146,147,149,413] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [337,338,302,458,150,153,317,319,320,321,322,305,332,334,425,438,431,432,436,437,434,439,441] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [227,230,332,333,331,334,243,315,316,320,225,150,165,172,175,153,173,168,188] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [667,669,670,692,696,698,716,717,718,719,720,721,618,761,763,672] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [115,118,98,81,13,408,3,404,405,406,128,5,398,7] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [413,409,410,411,8,510,415,513,405,401,403,14,17,18,16,143,358] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        