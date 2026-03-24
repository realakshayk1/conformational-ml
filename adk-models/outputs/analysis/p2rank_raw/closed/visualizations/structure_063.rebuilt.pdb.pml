
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
        
        load "data/structure_063.rebuilt.pdb", protein
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
 
        load "data/structure_063.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [33,36,60,61,74,76,64,65,72,21,23,25,535,537,538,541,78,80,93,95,98,533,1058,1060,1045,1059,1061,1063,20,524,13,59,57,595,63,988,990,994,995,996,997,1000,1008,73,992,1023,1042,542,543,978,681,682,683,685,678,58,588,592,593,594,416,417,15,525,408] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.278,0.702]
select surf_pocket2, protein and id [17,18,433,435,513,432,515,953,954,955,437,478,528,522,524,526,960,963,530,928,25,26,28,882,886,888,905,908,883,891,445,446,448,923,439,440,875,444,447,465,892] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.576,0.361,0.902]
select surf_pocket3, protein and id [319,320,324,317,318,321,322,323,325,458,473,474,475,476,477,478,340,342,503,335,338,339,341,413,415,431,433,513,432,510,430,429,461,462,463,465,443,445] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.616,0.278,0.702]
select surf_pocket4, protein and id [440,872,873,874,875,852,853,855,878,886,888,883,435,438,437,26,28,29,30,528,31,35] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.792]
select surf_pocket5, protein and id [553,551,554,990,58,55,593,572,574,575,585,33,34,36,60,54,38,53,56,59,555,560,577] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.447]
select surf_pocket6, protein and id [411,413,414,415,431,433,513,432,143,409,410,420,426,429,150,146,340,338,339] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.361]
select surf_pocket7, protein and id [416,417,418,134,135,136,421,408,130,15,21,23,25,13] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.447,0.278]
select surf_pocket8, protein and id [333,170,329,330,172,188,316,320,223,313,225,242,243,245] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.792,0.361]
select surf_pocket9, protein and id [666,669,670,716,717,718,721,698,761,762,763,618,663] 
set surface_color,  pcol9, surf_pocket9 
   
        
        deselect
        
        orient
        