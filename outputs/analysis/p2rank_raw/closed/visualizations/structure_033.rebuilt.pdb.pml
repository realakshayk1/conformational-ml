
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
        
        load "data/structure_033.rebuilt.pdb", protein
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
 
        load "data/structure_033.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [149,151,142,143,146,426,153,405,503,506,509,510,155,168,173,427,429,430,436,431,432,435,478,458,444,445,447,448,461,462,463,465,460,425,428,438,440,290,263,314,315,317,318,319,320,321,322,323,325,331,335,313,243,245,225,473,476,293,332,333,336,337,338,339,340,341,348,349,350,353,358,223,215,170,187,188,185,228,212,214,211,203,14,16,17,411,413,414,415,18,528,513,953,8,511,419,420,424,441,875,437,433,888,908,906,907,910,923,446,886,887,903,25,31,21,24,27,28] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [78,23,13,30,22,534,535,541,533,525,62,65,80,96,97,98,100,1063,118,83,76,82,408,15,415,418,93,1022,1024,1025,1026,1027,1039,1041,1042,1043,1040,1045,59,60,61,1023,73,74,75,58,978,543,55,542,987,988,990,985,1038] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [892,895,963,911,912,913,532,526,530,962,28,534,536,888,908,909,910,528,538,970] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [877,34,35,36,878,38,31,32,28,537,875,888,538,539,548] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        