
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
        
        load "data/structure_059.rebuilt.pdb", protein
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
 
        load "data/structure_059.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [543,20,23,533,1058,59,60,61,62,63,58,46,53,535,539,32,35,33,541,41,42,43,76,77,78,80,81,82,66,67,98,1042,1043,1063,1045,1060,96,93,118,83,1038,1041,1018,1019,1021,1022,1040,1023,988,978,981,985,416,417,418,420,411,412,25,15,19,21,408,10,16,12,13,523,103,137,138,135,5,3,141,146,148] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [428,429,437,413,431,432,434,478,433,503,476,322,323,338,439,441,435,460,463,448,436,27,28,887,888,907,908,910,953,879,886,906,875,873,18,524,525,513,515,528,526,31,35] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [312,313,245,263,265,225,220,243,244,320,328,315,316,317,318,310,153,169,170,171,172,186,187,332,168,333,222,223,224,205,155,173] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [665,698,715,724,725,610,672,673,696,763,766,663,628,758,759,761,762,728,755,727,662,660,616,618,767] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        