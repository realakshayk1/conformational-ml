
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
        
        load "data/structure_085.rebuilt.pdb", protein
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
 
        load "data/structure_085.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [80,1023,1024,1025,1026,1027,1028,1038,1041,1042,1043,1045,58,60,78,73,76,1010,978,1058,968,56,52,53,543,987,988,61,62,985,1000,1006,1007,1009,85,13,409,410,408,98,3,10,1063,82,16,21,22,23,532,533,12,523,26,30,63,24,33] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [143,145,403,411,412,8,397,133,135,383,149,150,413,505,513,502,503,504,11,15,414,357,358,353,355,337,338,340,428] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [426,151,152,153,413,505,513,503,143,145,412,149,150,18,414,320,337,338,340,358,427,428,432,430,433,318,460,477,478] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [428,435,433,953,923,528,530,960,908,28,538,888,889,890,904,905,892,893,906,907,910,873,478,18,20,534,535,515,413,513] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [671,672,663,664,665,669,670,694,696,695,733,697,699,700,618,763,716,717,719,721,698,726,727,731,710,725,673,620,626,653,624,627,628,762,728] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [243,239,240,329,330,331,332,333,220,221,222,226,236,223,188,170,313,237,238,310,312,315,328] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        