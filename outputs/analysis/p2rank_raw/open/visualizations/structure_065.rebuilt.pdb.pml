
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
        
        load "data/structure_065.rebuilt.pdb", protein
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
 
        load "data/structure_065.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [62,63,65,81,59,60,76,78,58,23,15,3,13,1045,1063,31,33,543,30,532,968,25,27,29,24,26,533,523,35,1023,1024,1025,1058,1038,1040,1042,1043,990,56,987,978,981,985,988,100,80,93,97,98,118,79,82,85,77,1026,1027,1028,73,1007,1008,1010,408,5,128,415,418,420] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [431,432,434,435,436,437,430,433,953,440,463,923,428,16,17,18,413,414,415,10,515,505,513,149,420,151,153,143,405,25,28,19,20,24,535,531,525,527,528,529,530,872,873,538,891,892,893,895,906,908,907,963,888,887,903,902,904,869,870,342,478,503,322,325,338,340,358,343,460,477,323] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [318,320,317,336,316,173,175,293,338,263,169,170,172,177,179,186,168,337,314,315,313,225,333,188,243,152,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [873,538,891,892,893,895,853,855,852,36,37,547,548,39,555,40,31,32,545,28,29,35] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [621,618,660,663,698,624,626,627,653,655,731,762,720,724,763,725,715,726,727,728] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [173,265,172,177,179,186,243,244,246,191,188] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [257,258,308,311,296,298,256,238,241,253,313] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        