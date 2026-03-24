
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
        
        load "data/structure_081.rebuilt.pdb", protein
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
 
        load "data/structure_081.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [422,424,425,412,416,420,426,427,428,141,142,143,144,145,146,410,135,411,413,17,18,511,513,515,133,402,403,405,406,151,152,153,147,25,20,527,317,319,320,321,333,322,325,337,155,335,168,171,338,340,500,502,503,355,357,358,383,380,223,314,188,173,263,245,172,175,193,174,191,243,433,436,437,885,429,430,431,432,435,445,463,923,886,27,28,31,875,888,890,528,908,907,438,440,35,873,447,903,904,905,458,460,323,465,473,474,475,476,477,478,288,318,316,293,313,262,261,265] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [76,77,78,93,95,81,83,82,96,97,98,100,21,22,23,541,542,543,20,535,533,1058,3,13,1060,1062,1063,1057,1059,1061,525,523,64,65,58,62,71,63,1038,1025,1041,1043,1042,985,978,73,1023,988,408,16,19,410,418,415,30] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [733,727,729,731,726,755,724,659,660,661,662,663,692,694,695,696,697,698,688,689,690,691,640,646,648,736,628,630,737,741,728,651,654,655,761,653] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [884,886,28,887,890,528,530,908,963,538,969,971,972,880,889,891,892,893,913,534,536,529,970] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [41,853,38,48,578,837,838,833,834,835,836,820,43,46] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [618,665,671,763,663,716,717,718,720,719,725,672,673,675,696,698,712,714,761] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        