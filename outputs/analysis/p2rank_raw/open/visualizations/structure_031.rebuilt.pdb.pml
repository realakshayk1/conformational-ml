
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
        
        load "data/structure_031.rebuilt.pdb", protein
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
 
        load "data/structure_031.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [23,533,523,518,13,1062,81,82,83,79,80,97,98,408,3,1063,1065,102,99,100,101,118,418,62,65,63,1025,1039,1041,1042,1043,1058,1045,1059,1061,71,73,74,75,76,58,77,78,978,968,543,55,988,542,990,1023,1038,1007,1008,1010,987,981,985,5,128] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [151,431,152,153,318,155,173,413,428,337,338,10,505,513,503,477,478,460,434,435,432,433,168,340,353,355,358,357,383,144,146,147,149,143,405,403,8,398,401,172,18,360,333,317,319,320,322,325] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [31,18,26,27,28,534,535,526,527,528,529,530,953,908,422,890,891,903,892,893,904,905,906,907,910,923,875,888,873,19,20,24,25,538,432,433,462,463,478,465,505,511,513,424,425,430,431,413,428] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [333,188,222,223,224,225,241,243,313,293,295,238,245,317,314,315,316,153,318,155,173,172] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [618,663,670,693,696,698,717,718,713,716,719,726,727,731,725,672,673,728,763,660,653,655] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [38,48,51,52,837,838,563,578,555,817,818,820,580,581,582,583,562,565,833,790,41,42,43,834,836,853,840] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [332,333,170,188,187,335,348,213,223,168,353,167,172,183] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        