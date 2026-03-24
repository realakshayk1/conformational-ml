
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
        
        load "data/structure_024.rebuilt.pdb", protein
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
 
        load "data/structure_024.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1042,1043,1045,1047,1058,58,60,78,79,80,1025,542,543,539,540,978,980,968,970,33,1038,1020,1022,1023,987,988,979,984,985,986,25,31,23,26,533,523,1063,62,63,64,66,40,418,417,408,5,13,419,420,98,96,97,95,118,1068,81,82,83,128,3] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [424,425,426,427,18,20,525,515,953,513,416,412,413,15,404,405,8,30,28,530,524,526,527,528,961,439,440,870,872,873,875,437,446,433,888,904,905,908,906,907,910,923,448,903,429,430,436,431,432,462,478,464,465,444,447,461,463,320,318,322,358,511,512,505,507,403,401,143,146,149,150,151,153,428,152,155,338,337,340,356,357,538] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [654,655,663,665,653,738,733,736,620,622,626,761,763,728,754,741,743,755,698,719,720,725,716,643,645,628] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [333,331,170,334,335,338,336,337,223,225,173,188,243,155,168,290,293,313,263,315,316,317,318] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [837,838,840,853,854,855,41,43,46,562,578,37,38,561,563] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        