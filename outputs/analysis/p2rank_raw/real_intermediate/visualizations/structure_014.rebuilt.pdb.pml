
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
        
        load "data/structure_014.rebuilt.pdb", protein
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
 
        load "data/structure_014.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [428,433,953,907,923,948,425,430,429,431,432,435,436,438,875,888,890,903,904,905,906,873,874,18,413,515,527,513,423,424,426,412,158,404,405,8,29,31,35,32,34,36,27,28,30,538,528,548,37,41,43,38,889,891,892,893,895,908,876,877,878,853,856,857,837,838,854,855,858,443,447,445,458,460,462,463,465,478,483,464,318,319,321,322,299,301,295,297,143,152,153,156,338,340,507,511,358,505,403,320,337,353,356,357] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [1043,523,533,1058,1059,1060,1042,1045,1063,62,78,60,63,58,23,79,82,80,93,94,96,97,98,100,1066,118,81,83,534,536,29,31,32,30,537,33,543,545,539,540,541,968,1025,978,980,985,404,405,406,407,408,409,410,411,3,5,13,128,15,418,25,421,415] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [663,733,696,698,700,725,712,716,710,610,664,673,672,713,624,626,627,618,728,731,736,727,763,620,653,654,655,738,660,665] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [41,43,46,47,48,833,38,578,816,817,818,790,598,792,794,795,834,835,836,837,838,855,820,819,821,822,853,562,563,565,581,582,583] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [358,383,403,385,143,340,356,357,404,405,8,413,513] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [160,157,173,263,155,227,228,315,333,291,293,295,243,313,314,316,317,318,158] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        