
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
        
        load "data/structure_048.rebuilt.pdb", protein
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
 
        load "data/structure_048.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [478,465,481,483,424,425,427,430,431,432,433,434,435,436,438,439,322,323,460,473,319,321,318,28,528,530,535,953,440,447,448,873,886,887,888,903,904,905,923,457,459,461,458,889,890,891,892,895,906,907,908,875,15,18,10,405,403,509,510,511,512,513,507,411,413,416,426,428,143,145,151,152,153,155,149,150,333,336,337,338,339,320,340,358,503,506,168] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [542,978,1058,1041,1042,1061,1063,78,93,1025,1043,94,95,1045,543,988,60,62,64,65,75,1023,984,985,986,987,98,97,128,408,130,13,14,15,21,22,533,11,523,525,3,118,5,415,418,23,25,410,409,103,134,136,137,138,81,82,83,85,532,968,31,33,36,541,40] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [728,719,720,726,727,736,743,745,731,627,761,762,763,618,665,628,653,655,738,663,733,697,717,698,716,671,670,672,673,675,688,641,642,644,648,631,636,638] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [168,172,173,242,243,170,188,218,221,223,226,228,203,213,215,329,330,331,332,333,320,348,155,328,314,315,316,317,318,312,313] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        