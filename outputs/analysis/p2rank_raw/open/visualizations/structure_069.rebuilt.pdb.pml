
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
        
        load "data/structure_069.rebuilt.pdb", protein
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
 
        load "data/structure_069.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [15,18,416,420,153,412,413,8,505,513,503,403,405,383,145,150,143,337,338,340,358,357,426,427,428,429,431,430,432,28,433,527,525,528,530,535,538,29,31,32,34,35,36,548,30,37,38,462,463,888,465,435,889,893,891,892,906,908,904,905,907,855,872,873,852,853,320,321,322,323,478,460] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [1058,1059,1060,1042,1043,63,65,58,60,62,543,1023,1044,1045,1063,1062,1065,78,81,80,1025,15,20,21,22,23,533,532,10,13,520,523,82,83,102,408,85,101,97,98,3,118,128,130,404,406,407,9,536,539,540,978,531,970,968,30,26] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [38,41,43,48,578,556,834,836,837,838,559,560,561,562,565,853,835,833,817,820,581,582] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [288,287,293,295,263,317,318,320,243,314,315,265,262,172,173,228,333,227,225,155,157,160,153] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [643,653,655,628,727,728,618,620,622,626,627,762,763,663,720,716,726,731,733,725] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        