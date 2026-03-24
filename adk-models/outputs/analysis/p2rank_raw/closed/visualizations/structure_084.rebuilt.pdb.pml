
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
        
        load "data/structure_084.rebuilt.pdb", protein
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
 
        load "data/structure_084.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [908,960,910,923,954,888,882,884,886,889,891,896,900,16,520,522,956,8,870,873,877,879,880,881,883,411,416,17,18,19,20,412,25,409,410,527,528,893,963,892,30,27,28,512,513,953,478,479,480,503,505,481,462,466,470,483,467,438,437,440,435,463,460,461,145,426,428,429,338,431,433,340,432,143,405] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [98,1060,1062,1063,533,535,62,65,79,81,83,78,33,23,99,100,113,82,137,128,406,409,410,415,414,15,13,5,10,12,524,525,3,118,1042,1043,1040,974,975,976,977,978,971,1045,1058,60,543,542] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [543,551,573,986,988,52,53,54,589,590,591,541,546,549,554,556,560,577,578,60,593,987,989,992,993,30,32,33,34,36,855,39,40,56,23,62,61,59,537,538,598,37,41,838,43,35] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [1008,73,58,682,686,687,60,989,990,543,1043,1026,1027,1028,1023,978,997,1000,1020,62,65,76,77,74,64,66,78,72,93,660] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        