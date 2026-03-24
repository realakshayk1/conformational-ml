
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
        
        load "data/structure_039.rebuilt.pdb", protein
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
 
        load "data/structure_039.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [77,78,82,98,93,97,1063,1068,95,65,76,74,75,542,531,533,968,1060,62,63,64,543,60,13,15,408,11,523,9,415,417,418,23,83,99,100,128,3,5,118,1023,1042,1043,1022,1025,1041,1039,1040,1044,1045,73,988,977,978,1058,55,58,990,981,983,1038] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [25,27,18,28,528,953,422,423,886,887,888,891,903,904,905,906,907,908,923,875,16,17,411,409,513,421,412,413,410,530,31,424,426,427,429,431,432,434,436,430,433,478,503,504,505,506,507,509,511,425,448,460,463,465,435,440,143,145,403,405,406,510,338,476] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [333,316,220,226,227,173,243,315,238,241,312,313,245,262,337,317,320,328,331,336,338,310,318,290,258,259,293,261,353,221,222,223,224,225,153,263,150,151,152,155,168,145] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [29,30,31,32,33,36,880,37,38,41,857,538,893,838,874,875,876,877,878,879,888,891,873,853,856,28] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [143,145,403,510,427,429,430,478,502,503,500,337,341,338,339,340,342,358,413] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [713,714,715,712,663,693,696,665,671,672,673,618,765,763] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [349,351,353,335,170,188,348,213,215,223,333,167,168] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        