
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
        
        load "data/structure_033.rebuilt.pdb", protein
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
 
        load "data/structure_033.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [78,83,79,81,82,80,85,98,1039,1041,1042,1043,1045,1062,1063,93,96,97,113,58,60,62,63,1058,1040,1061,542,533,536,540,974,976,978,968,971,33,543,988,987,1023,1038,1022,1025,985,2,3,4,5,6,400,406,407,408,100,99,101,118,128,13,16,12,9,10,522,523,960,23,22] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [436,439,441,433,463,462,478,465,907,908,926,903,923,904,906,888,891,444,446,447,448,451,18,20,527,528,515,953,25,27,28,505,513,427,428,429,431,413,892,30] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [149,150,426,427,428,429,412,413,505,143,146,410,403,405,152,153,151,430,432,435,458,460,478,168,338,340,358,318,320,321,322,323,473,503] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [188,226,333,223,313,312,315,316,241,243,295,224,225,220,222,238,170,171,172,173,168,317,318,290,293,155] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [719,720,721,722,724,755,763,716,717,710,712,624,626,628,760,725,726,727,728,731,735,663,733,694,695,698,653,654,655,657,661,618] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [41,43,46,48,50,53,578,38,853,555,835,837,838,840,559,560,561,562,576,577,580,553] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        