
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
        
        load "data/structure_092.rebuilt.pdb", protein
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
 
        load "data/structure_092.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [93,1043,1025,1041,1042,1058,1044,1045,1057,1059,1061,1063,1060,58,63,73,74,75,76,77,78,1023,545,988,543,978,1038,1022,998,987,981,984,985,986,15,533,523,13,61,62,64,65,23,80,94,96,97,98,95,3,118,408,4,5,128,416,417] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.278,0.702]
select surf_pocket2, protein and id [513,515,953,511,421,422,424,425,428,413,415,429,430,431,435,433,437,447,448,903,923,28,886,887,888,890,535,528,529,530,906,907,908,955,884,902,16,18,20,25,478,475,477,483,463,465,340,503,323,338] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.576,0.361,0.902]
select surf_pocket3, protein and id [333,336,322,155,171,172,323,337,338,168,169,173,223,331,332,328,315,215,224,330,348,243,226,227,188,228,186,203,213,318,317,458,478,475,460,152,153,427,436,438,428,431,432,433,150] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.616,0.278,0.702]
select surf_pocket4, protein and id [143,142,411,404,406,403,8,405,139,140,135,133,513,507,510,413,430,14,16,18,340,503,506,353,355,357,358,359,360] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.792]
select surf_pocket5, protein and id [333,336,337,338,340,353,358,168,428,152,153,143,150] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.447]
select surf_pocket6, protein and id [61,62,64,65,25,23,31,40,417,63,78,543,60] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.361]
select surf_pocket7, protein and id [838,818,578,581,553,38,53,560,41,43,46,48,835,820,834,836,35,37,853,840] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.447,0.278]
select surf_pocket8, protein and id [79,81,82,83,85,80,98,103,65,137,138,131,134,135,136,408,410,418,416,417] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.792,0.361]
select surf_pocket9, protein and id [660,663,736,731,733,727,728,726,720,725,763,697,700,695,643,653,738] 
set surface_color,  pcol9, surf_pocket9 
   
        
        deselect
        
        orient
        