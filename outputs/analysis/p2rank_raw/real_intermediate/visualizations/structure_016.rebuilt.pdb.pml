
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
        
        load "data/structure_016.rebuilt.pdb", protein
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
 
        load "data/structure_016.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [61,62,63,65,66,67,68,23,533,523,80,96,97,98,99,101,118,82,83,21,22,24,26,30,531,411,405,407,408,409,13,3,128,138,148,414,416,415,418,93,1025,1027,1028,1039,1042,1043,1040,1044,1045,1062,1063,1060,60,76,78,58,543,988,539,540,541,542,978,968,53,990,987,981,984,985,1038,1023] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [428,429,431,432,430,15,18,413,14,512,511,513,953,948,950,421,422,425,433,463,888,890,904,906,923,25,31,32,27,28,538,528,955,963,907,908,910,926,35,889,892,874,875,876,877,891,893,873,460,462,465,478] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [340,358,503,480,504,505,152,153,155,168,337,338,320,333,460,478,427,429,430,15,18,413,14,512,511,513,143,403,405,8] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [152,153,318,154,155,168,338,157,160,169,171,173,263,315,317,319,320,313,333,224,225,226,227,228,243,293,295,300,287,158] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [609,621,619,659,663,618,763,660,736,738,733,727,728,731,725,673,692,693,713,714,715,696,698,610,653,654,655,626,628] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [34,35,36,37,41,43,31,32,873,855,853,854,874,875,876,877,893,425,428,38] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [153,318,156,338,157,319,320,321,322,303,458,301,295,302,424,425,158,423,426,429,430,438,436] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [48,833,815,817,818,820,41,43,46,836,837,838,853,578,579,580,581,582,565,583,38,562,563] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        