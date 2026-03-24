
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
        
        load "data/structure_017.rebuilt.pdb", protein
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
 
        load "data/structure_017.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [25,413,426,409,410,15,18,511,512,513,515,405,430,433,434,953,477,478,502,503,504,506,476,403,383,151,427,428,429,318,431,432,338,153,143,145,168,336,337,339,341,342,343,340,353,356,357,500,358,474,320,326,322,20,528,529,531,534,535,536,538,963,28,970,888,892,906,907,910,908,435,463,462,465,458,460,473] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [80,82,83,85,101,102,103,23,61,62,63,20,530,531,533,534,535,97,98,115,118,525,523,524,1063,138,136,137,408,130,418,2,6,128,3,13,16,10,1038,1025,1042,1043,1058,1045,52,77,76,78,73,1023,1022,1024,1026,541,542,543,988,55,539,978,540,53,54,987] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [151,427,428,318,317,338,153,145,168,155,169,171,172,173,293,243,263,333,334,336,337,335,225,227,228,230,320,312,313,314,316,438,426,425,291] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [660,618,662,663,696,698,724,725,731,697,716,717,624,625,628,763,720,728,726,727,653,655] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [423,158,148,25,418,419,421,422,58,60,66,67,63,24,31,32,33,34,35,64,65,83] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [427,428,429,318,431,432,338,320,322,425,430,436,426,438,441,443,458,460] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [595,683,668,52,71,73,990,1007,1008,47,51,53,54,593,58,60,56,66,68,613] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        