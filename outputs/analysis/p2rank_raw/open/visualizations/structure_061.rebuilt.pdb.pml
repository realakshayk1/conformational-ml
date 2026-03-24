
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
        
        load "data/structure_061.rebuilt.pdb", protein
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
 
        load "data/structure_061.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1043,1063,1041,1042,1062,1066,1067,1068,78,79,80,81,93,56,58,60,62,978,1058,1060,1023,1025,985,987,980,543,536,540,969,976,968,988,85,100,97,98,3,116,117,118,65,82,83,13,20,532,533,523,23,63,405,407,408,410] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [151,153,428,15,413,510,513,505,402,403,404,8,398,401,144,145,143,155,152,18,431,432,433,434,435,458,460,336,337,340,353,354,355,356,357,358,383,360,385,168,333,173,321,322,319,338,478,503,318] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [34,35,28,953,528,907,908,923,950,430,432,433,440,462,463,460,465,889,890,892,893,895,904,905,906,873,888,887,903,18,21,530,24,25,420,27,29,31,26,32,513,515,505,545,538,38,36,478] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [655,620,663,618,670,693,692,696,697,731,622,626,627,628,653,671,672,673,669,717,720,713,716,762,763,719,755,725,726,727,728,712] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        