
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
        
        load "data/structure_002.rebuilt.pdb", protein
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
 
        load "data/structure_002.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1023,78,80,93,1043,1025,1059,1060,1061,1062,1063,1064,1068,1058,1044,1045,61,62,65,73,76,58,535,978,968,970,974,975,543,988,56,1038,1022,990,981,984,21,20,22,23,24,523,533,13,3,1065,63,25,35,415,408,5,94,95,96,97,98,118,82,85,81,128] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [420,426,427,431,434,18,433,435,428,513,904,905,906,923,15,413,405,145,21,24,26,27,528,530,875,28,888,907,908,887,153,432,429,430,338,476,502,510,477,478,503,460,463,343,501,337,320,325,341,474,475,323,403,358,143,144,339,340,342,356,357,538] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [330,312,315,317,320,328,313,224,225,243,242,294,295,153,318,173,263,170,172,188,221,222,226,211,212,214,332,333,348,215,155,169,171,168] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [33,37,545,547,551,558,38,561,562,563,578,49,51,53,838,818,821,822,565,583,598,577,579,580,581,43,833,817,835,836,837,853,820,834,36,41,876,877,878,47,48,42,46,873] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [543,544,988,54,56,55,52,53,545,551,553,61,62,58,990,992,573,574,575,35] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [763,765,659,660,661,663,761,719,720,722,725,726,724,728,698,692,693,715,714,673,626,627] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [513,953,511,18,923,907,908,910,963,524,525,526,528] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        