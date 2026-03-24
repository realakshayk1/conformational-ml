
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
        
        load "data/structure_009.rebuilt.pdb", protein
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
 
        load "data/structure_009.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [422,423,424,426,440,28,888,890,528,907,908,953,923,889,891,903,906,875,885,15,17,18,405,10,515,520,411,413,420,35,530,892,895,513,502,503,143,146,427,149,151,152,153,168,428,403,433,478,460,462,463,465,429,430,431,432,434,435,437,439,441,458,319,320,321,333,334,335,473,318,338,340,358,336] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [77,78,25,61,62,63,533,1043,523,968,1058,96,97,98,93,1063,1065,118,79,80,81,82,83,85,33,543,1025,1041,1039,1040,1042,1023,988,978,416,19,21,22,23,409,410,13,137,408,3,5,138,145,418,421] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [229,230,243,240,241,242,313,317,333,314,315,316,318,296,258,227,292,293,263,157,155,173,154] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [653,654,655,656,659,660,663,626,628,761,762,763,717,731,727,728,720,726,755,725,698,716,697,645,643] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [29,31,35,32,34,36,30,544,545,547,548,541,538,37,38,893,892,28,875,885,889,891] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [851,852,853,41,44,38,46,836,837,48,838,43,835,873,833] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        