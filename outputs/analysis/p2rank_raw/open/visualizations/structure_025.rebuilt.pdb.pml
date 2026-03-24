
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
        
        load "data/structure_025.rebuilt.pdb", protein
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
 
        load "data/structure_025.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [60,65,78,79,80,81,82,83,1025,13,1063,1041,1042,1043,1045,103,94,95,96,97,99,101,98,118,93,1030,85,59,64,25,23,26,532,533,534,535,523,525,30,63,543,539,540,541,542,974,976,977,978,1058,968,969,971,975,56,55,988,57,415,130,407,408,410,3,5,10,11,128,138,141,145,418,421,1038,1023,987,990,985] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [420,425,427,428,429,153,431,432,413,18,478,513,510,509,506,458,433,460,434,435,151,145,146,149,143,15,412,403,405,8,401,155,150,336,333,168,337,338,340,353,354,356,357,358,355,166,171,172,173,317,318,320,322,503,473,476,477,293,325,323] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [18,478,513,509,511,515,953,428,429,430,431,413,903,923,433,463,907,908,906,890,892,20,28,535,527,528,529] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [663,717,718,720,727,731,725,696,698,715,670,690,672,673,619,620,653,618,759,760,762,763,755,728,627,628] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [538,908,963,873,35,889,890,891,892,893,895,875,20,28,535,528,529,530,31,970,888,430] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        