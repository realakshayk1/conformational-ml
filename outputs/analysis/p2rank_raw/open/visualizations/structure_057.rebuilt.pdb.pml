
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
        
        load "data/structure_057.rebuilt.pdb", protein
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
 
        load "data/structure_057.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [3,13,1042,1043,1044,1045,1058,1060,1062,1063,65,81,82,83,60,62,58,77,78,79,408,100,102,80,85,93,94,95,98,99,101,1066,118,1024,1025,1030,1027,968,543,533,541,523,20,23,26,63,978,985,11,518,4,5,404,405,406,407,128,1,395] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [895,901,906,907,908,882,886,891,892,893,873,435,433,463,887,888,905,923,883,446,448,447,903,451,466,25,27,28,420,21,24,531,527,528,529,953,31,535,538,530,963,969,35,972,973,424,428,431,18,513,515] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [416,143,412,402,403,404,405,8,10,398,401,133,147,149,146,151,426,427,428,429,430,431,413,18,513,152,153,150,338,339,340,341,505,358,503,478,353,383,357,385,325,342,25,433,460] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [663,732,733,692,693,696,698,763,725,727,728,717,721,712,716,706,729,730,731,703,653,655,610,618,666,669,671,718,673,670,672,621] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        