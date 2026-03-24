
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
        
        load "data/structure_019.rebuilt.pdb", protein
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
 
        load "data/structure_019.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [429,430,18,28,428,431,432,953,416,21,411,412,413,415,8,10,511,513,515,510,151,420,153,890,463,906,907,908,910,923,875,435,433,888,143,403,405,7,398,401,144,145,24,531,27,26,30,536,538,529,528,530,963,33,880,891,892,893,877,338,353,323,340,356,357,358,477,478,502,503,504,505,506,354,475,339,476,465,473,462] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.616,0.278,0.702]
select surf_pocket2, protein and id [61,62,63,25,57,59,66,43,22,23,533,523,543,545,535,541,31,35,40,60,39,78,80,85,93,96,97,98,1063,118,77,79,81,82,83,67,68,1038,1043,1025,1045,73,988,978,980,990,55,13,418,421,137,141,135,408,410,3,5,128,138,139,146,148,163] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.361]
select surf_pocket3, protein and id [872,873,875,434,435,437,440,433,888,446,447,422,423,424,426,425,438,28,431,29,31,35,32] 
set surface_color,  pcol3, surf_pocket3 
   
        
        deselect
        
        orient
        