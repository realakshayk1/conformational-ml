
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
select surf_pocket1, protein and id [953,511,513,426,428,431,427,429,430,15,18,413,432,433,436,435,887,888,32,33,20,26,535,28,528,962,963,420,890,892,895,907,908,909,910,875,889,891,893,478,507,463,459,460,465,538] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [61,62,63,23,19,21,22,532,533,13,523,525,24,25,29,30,536,531,529,530,40,80,82,100,96,97,98,3,1063,95,118,66,81,83,408,5,9,10,128,415,418,1023,1039,1040,93,1043,1025,1041,1042,58,76,78,988,59,543,539,540,541,980,968,970,55,986] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [339,340,338,154,155,168,318,320,478,503,426,431,427,429,430,18,413,510,513,151,152,153,403,405,143,145,149,150] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [312,314,315,316,317,318,320,293,288,291,262,263,245,155,168,172,173,174,175,332,333,331,225,313,243,224,226,227,228,230] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [621,762,763,618,659,661,664,666,720,724,725,726,727,755,698,715,695,694,669,670,624,625,626,628,622,655] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [43,833,834,815,838,814,816,817,46,41,48,578,580,598,565,818,50,560,562,563,37,555] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        