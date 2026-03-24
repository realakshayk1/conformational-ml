
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
        
        load "data/structure_047.rebuilt.pdb", protein
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
 
        load "data/structure_047.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [98,1043,1058,1042,1063,1062,100,78,79,80,81,82,83,85,63,60,62,65,1038,1040,1023,1024,1025,23,532,533,970,520,523,525,968,543,542,985,978,981,13,15,415,408,407,9,11,2,3,6,118,138,10,518,519,521,21] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [433,436,440,462,463,466,923,953,447,448,449,451,887,888,903,902,905,18,511,513,515,505,430,873,891,892,893,895,906,908,904,907,28,537,538,526,527,528,530,963,29,30,478,480,503] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [18,413,513,504,420,428,151,153,14,412,403,405,401,8,9,11,7,398,143,144,145,146,149,433,431,432,337,338,339,340,341,342,502,503,353,357,358,360,385,383,478,320,325,460] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [38,40,46,835,36,30,541,539,538,853,834,836,837,840,838,559,560,561,562,578,556,548,48,544,546,547,551,820,833] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [172,173,333,293,318,314,315,317,176,191,243,225,228,153] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [720,726,727,728,731,618,620,663,763,696,698,669,670,671,672,673,692,693,715,655,627,628,762] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        