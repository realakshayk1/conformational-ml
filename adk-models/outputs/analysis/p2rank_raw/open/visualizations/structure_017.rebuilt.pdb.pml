
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
        
        load "data/structure_017.rebuilt.pdb", protein
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
 
        load "data/structure_017.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [60,62,64,65,66,67,83,80,78,1043,1045,1062,1063,98,97,100,113,22,23,533,535,541,523,968,31,35,63,543,26,1023,1025,1058,1042,1000,986,987,978,979,980,985,988,407,408,13,3,5,102,129,130,118,128,418,10,421] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [427,429,15,18,413,428,510,513,151,420,430,153,143,412,404,403,405,402,8,397,398,401,147,149,150,320,322,336,338,341,503,317,318,333,337,339,340,342,353,357,358,168,335,170,169,171,173,433,323,460,478] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [433,445,462,463,888,465,903,905,923,435,478,895,963,907,908,538,892,893,891,904,906,887,528,953,513,505,509,511,431,18,25,428,20,28,531,535,527,529,530] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [655,618,620,660,663,733,719,720,763,724,725,727,728,731,712,713,716,717,696,697,698,669,692,693,694,610,673,671,672,628,627,653] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [1010,1023,1024,1025,1026,1027,1028,1000,1006,1007,987,60,73,76,80,77,78,1043,93,74,75] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        