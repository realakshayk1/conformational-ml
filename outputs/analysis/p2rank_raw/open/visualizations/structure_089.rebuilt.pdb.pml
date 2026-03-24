
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
        
        load "data/structure_089.rebuilt.pdb", protein
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
 
        load "data/structure_089.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [78,79,80,81,93,1043,1041,1042,1045,1063,65,76,60,62,63,55,532,533,978,1058,1023,1025,1027,990,988,977,981,985,1038,1039,1040,542,543,541,974,976,968,975,82,86,87,101,103,408,97,98,100,3,4,5,118,23,13,523,418,83,417,136,128,130,138,410,6] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [427,428,405,413,430,511,513,152,153,151,143,403,144,146,18,431,432,433,462,463,460,478,505,318,473,476,477,504,338,358,357,503,168,319,320,321,322,325,493,323,353,333,337,339,340,341,342,356] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [28,528,953,907,908,431,462,463,465,478,505,905,923,890,892,895,904,906,524,526,18,20,430,511,513,515,481] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [28,31,35,528,908,431,436,437,438,439,440,441,433,462,463,888,445,875,889,891,893,890,892,873,27,18,20,422,423,426,430,424] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [293,243,244,245,314,315,317,316,263,175,188,193,333,223,171,172,173] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [46,38,578,580,555,836,837,838,48,49,50,51,818,598,820,43,833] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [626,653,654,655,627,628,760,755,761,762,763,728,660,720,725,727,729,730,620,663,698] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [578,579,580,581,838,565,48,820,822,825,818,582,583] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        