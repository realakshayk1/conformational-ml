
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
        
        load "data/structure_006.rebuilt.pdb", protein
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
 
        load "data/structure_006.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [24,26,27,19,28,536,538,528,964,963,25,31,970,972,973,965,889,890,891,892,893,906,907,911,912,913,875,428,430,18,433,478,515,953,505,507,511,513,435,903,888,904,905,908,923,463,462,465,483,434,413] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [412,413,405,8,510,144,145,146,147,149,151,420,153,142,143,401,403,133,390,397,398,385,426,428,431,18,433,478,506,513,458,460,338,339,340,353,356,357,358,360,383,168,323,477,502,503,320,368] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [78,82,80,98,1043,1042,1045,1063,97,118,93,83,23,523,1058,533,535,968,12,13,16,9,10,128,408,3,5] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [63,58,59,60,61,62,23,78,82,80,98,1043,1025,65,541,542,978,543,533,535,30,1023,988,986,987,984,418] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [727,728,731,745,732,734,736,738,740,620,621,720,762,763,715,698,622,624,626,627,628,643,651,652,653,663,733,670,697,618] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [318,320,287,291,285,169,171,172,173,175,170,168,334,336,337,152,153,224,225,240,241,223,333,335,293,313,188,243,263] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        