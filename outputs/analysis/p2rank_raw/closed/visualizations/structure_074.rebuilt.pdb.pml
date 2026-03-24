
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
        
        load "data/structure_074.rebuilt.pdb", protein
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
 
        load "data/structure_074.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [14,15,20,23,1058,13,1063,59,60,61,62,63,65,73,74,76,77,78,33,543,533,542,523,530,969,53,97,98,1043,1045,1068,75,79,80,81,82,83,86,96,101,118,411,414,408,11,416,418,144,145,148,136,137,130,128,103,1024,1025,1041,1042,1040,1023,58,987,974,976,977,978,986,971,975,989,990] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [420,433,436,437,438,428,429,430,434,435,18,513,515,953,483,873,888,903,904,905,441,447,448,463,410,509,478,35,28,535,524,525,526,528,907,908,910,30] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [339,341,342,343,478,503,506,320,338,356,358,143,335,353,344,345,323,460,474,475,477,425,426,427,431,428,432,410,413,140,405,510,144,145,147,149,150,151,152] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [243,245,263,319,320,331,173,225,315,223,224,172,174,175,176,177,178,193,333,228,313,288,289,290,317,318,152,153,154,155] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [663,715,757,675,688,690,720,725,662,664,665,666,668,672,674,656,657,658,659,652,653,730,661,628,759,760,727,728,729] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [418,148,421,153,156,158,161,422,423,63,65,83] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        