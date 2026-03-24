
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
        
        load "data/structure_071.rebuilt.pdb", protein
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
 
        load "data/structure_071.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [17,18,411,513,522,524,525,432,433,409,8,404,405,406,407,511,514,515,521,953,25,415,421,422,424,425,426,428,429,430,413,431,143,146,144,325,338,341,343,358,477,478,503,505,320,336,322,526,528,960,27,888,908,911,925,885,890,909,905,913,963,923,926,928,436,437,875,434,435,28,445,462,463,458,459,460,465,476,318,323,473,538,886,891,889,892,903,893,879] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [63,76,78,73,79,80,81,82,93,94,96,33,60,542,543,23,541,533,535,1058,1043,98,1060,95,97,100,1059,1063,1044,1046,978,1023,988,990,408,5,118,128,13] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [316,317,173,243,186,187,188,172,175,167,168,169,170,171,313,221,222,223,225,228,213,216,263,244,245,320,328,329,330,331,333,312,348,353,349,351,352,152,150,318] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [320,333,336,145,338,173,172,168,169,171,428,413,143,146,144,149,152,153,150] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [665,671,672,693,696,716,717,698,712,720,761,762,763,764,765,618,770,663] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [550,553,988,989,990,991,992,593,60,543,545,52,53,54,55,56,58] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        