
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
        
        load "data/structure_029.rebuilt.pdb", protein
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
 
        load "data/structure_029.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [15,17,18,28,528,526,953,954,515,531,536,966,969,887,888,890,30,538,908,970,907,911,961,962,963,955,923,886,892,903,895,904,906,912,913,905,875,433,429,430,431,432,476,435,463,465,477,478,948,447,448,143,405,407,409,411,413,427,428,502,503,510,511,513,8,423,424,425,440,149,150,151,416,421,146,426,338,339,340,325,500,318,320,321,322,335,153] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [23,533,534,535,541,523,968,1060,1061,15,408,13,25,11,60,61,62,63,35,543,417,418,78,80,83,96,97,1062,1063,85,93,118,138,100,103,129,130,98,128,3,5,125,406,410,136,134,135,416,137,1038,1041,1043,1022,1025,1042,1040,1045,978,985,542,974,975,976,977,984,1058,971,58,1023,987,988,986,998] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [872,873,856,875,877,878,834,835,836,838,853,36,37,38,41,42,46,48,31,32,33,420,43,29,888,30,538,891,892,893,28,424,425,440,437,439,422,436,551,555,561,562,547,548,578,581,565,818] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [220,221,222,225,229,230,243,245,239,240,313,259,258,227,260,293,172,173,174,175,170,152,153,333,311,312,316,317,318,320,309,310,328,263,262] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [645,652,653,638,728,657,656,626,627,758,730,725,727,729,755,661,659,660,663] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [664,660,663,730,733,725,727,729,755,715,688,694,695,696,712,714,697,698,699,710,671,672,673,675] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        