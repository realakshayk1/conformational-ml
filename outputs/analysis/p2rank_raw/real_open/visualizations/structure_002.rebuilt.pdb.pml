
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
select surf_pocket1, protein and id [421,422,25,21,27,28,18,528,953,515,424,425,426,427,430,431,436,153,428,433,460,505,513,503,477,478,463,462,465,440,875,887,888,889,890,891,892,903,907,908,923,910,870,872,873,417,15,415,14,16,11,405,144,145,146,147,149,150,151,413,338,143,403,8,383,385,538,963,893,322,325,343,323,340,341,356,357,358,337,339] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [1025,1043,1045,1042,1063,61,62,65,58,78,79,80,543,30,533,540,542,978,1058,530,968,63,987,985,1023,988,1007,1008,1024,1026,13,523,418,15,414,415,23,411,3,100,118,83,408,82,97,98,22] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [335,333,337,353,340,169,170,171,173,314,315,317,318,320,293,295,243,225,146,149,150,168,151,152,338,143,156,157,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [618,663,698,762,763,724,725,728,733,727,731,732,736,696,697,716,660,654,655,653,628,738] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [43,820,833,818,578,563,38,834,836,838,835,837,48,580,598,579,581,565,582,583] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        