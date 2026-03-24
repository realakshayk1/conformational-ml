
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
        
        load "data/structure_041.rebuilt.pdb", protein
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
 
        load "data/structure_041.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [418,19,21,22,23,25,533,535,520,525,5,11,13,1063,61,62,63,65,66,59,78,94,95,96,97,98,1062,3,103,121,117,118,67,83,79,82,68,31,32,33,34,35,36,37,38,30,853,838,841,421,417,409,7,8,135,137,410,406,407,408,128,1,398,131,132,127,126,393,148,151,153,156,157,158,161,423,978,985,93,1043,1025,1042,1044,1045,1058,1061,1066,1067,73,58,541,970,988,546,547,548,549,551,553,543,55,560,1023] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [433,435,513,953,18,888,903,463,905,908,923,28,528,536,538,529,530,526,910,963,889,890,895,20,465,481,483,478] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [323,325,338,477,478,480,496,497,498,499,500,503,322,460,473,474,475,476,458,341,342,358,343,433,429,430,428,431,432,18,412,415,413,405,506,510,403] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [319,320,321,322,333,173,317,318,338,335,168,425,427,429,430,438,428,151,152,149,150,153,155,144,145] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [335,353,168,341,354,355,358,166,337,338,146,413,144,145,142,143,151,152,149,150,428] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [763,663,665,667,618,610,716,717,720,673,698,670,671,697] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        