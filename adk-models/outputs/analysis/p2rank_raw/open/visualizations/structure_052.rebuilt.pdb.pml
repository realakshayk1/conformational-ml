
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
        
        load "data/structure_052.rebuilt.pdb", protein
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
 
        load "data/structure_052.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [416,25,428,15,17,18,19,413,14,16,8,11,12,520,513,515,149,151,425,427,431,435,445,429,430,432,433,462,463,888,903,904,905,405,402,403,401,143,146,150,20,24,535,524,526,537,28,538,970,893,528,530,963,907,908,891,892,895,906,873,153,318,321,322,333,325,337,338,478,480,168,340,353,357,358,383,385,323,460,475,465,476,477] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [1043,1058,1045,1062,1063,1042,62,65,75,83,78,23,20,22,533,523,525,536,540,968,543,80,97,98,99,100,101,102,113,118,79,81,82,85,978,985,1023,1024,1025,135,404,405,406,408,126,5,120,128,13,9,10,11] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [833,834,835,836,837,838,818,817,819,820,821,822,38,48,41,43,46,578,579,581,565] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [725,727,728,731,660,663,618,717,719,763,716,695,624,626,653,627,762] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        