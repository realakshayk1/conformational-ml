
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
        
        load "data/structure_043.rebuilt.pdb", protein
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
 
        load "data/structure_043.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [423,419,420,424,426,428,436,437,427,431,432,412,413,409,410,15,513,405,338,429,430,142,143,145,140,478,503,505,476,477,151,152,153,154,155,168,434,435,903,905,923,925,433,463,18,535,527,528,26,27,28,17,21,887,888,908,906,907,910,875,342,343,495,340,333,315,320,322,324,325,336,341,337,335,353,354,356,473] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [533,1058,1063,1065,1043,1046,1061,96,16,19,21,518,519,520,521,523,10,13,3,98,97,100,118,23,65,76,78,79,81,82,83,80,93,58,60,61,62,63,73,534,535,536,539,540,40,25,541,542,543,1025,1041,1042,1039,1047,975,978,987,988,1023,984,986,408,415] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [351,353,188,333,332,315,330,331,221,222,224,225,226,328,213,191,192,189,190,173,243,170,168,169,171,172] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [43,37,38,41,46,48,49,51,52,50,578,853,835,838,581] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [83,103,98,414,415,141,146,136,137,138,411,130,408,148] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        