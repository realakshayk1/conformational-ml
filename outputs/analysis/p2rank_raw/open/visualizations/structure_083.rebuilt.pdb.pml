
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
        
        load "data/structure_083.rebuilt.pdb", protein
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
 
        load "data/structure_083.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1024,1025,1042,1043,1044,1058,1040,1045,1063,58,60,65,73,76,80,78,1023,96,97,93,94,95,113,82,83,77,85,1010,1027,1028,23,533,535,63,543,542,978,981,982,968,987,988,990,984,985,408,3,13,98,128,101,102,103,130,118,129,132,136,521,523,518] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [433,462,463,538,893,907,908,953,435,440,873,888,903,889,890,891,904,905,906,923,892,478,481,465,483,18,413,20,28,528,515,505,511,513,430,428,30,529,530,32,33,34,35,36] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [18,412,413,505,513,151,416,420,430,153,427,428,429,403,405,401,145,143,337,338,340,343,318,319,320,321,322,324,325,480,502,503,356,357,358,168,478,458,460,473,474,475,476,477,323,431,432,433] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [171,172,173,242,243,314,315,316,317,318,320,333,225,170,188,245,262,263,155,153,291,293,313,260] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [838,562,563,565,555,38,853,835,836,837,833,818,817,819,820,583,840,50,43,46,48,578,580,49,51,41,581,582] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [626,726,727,728,618,763,620,653,655,628,663,720,715,719,724,725] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        