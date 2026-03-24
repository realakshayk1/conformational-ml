
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
        
        load "data/structure_022.rebuilt.pdb", protein
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
 
        load "data/structure_022.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [523,1043,1045,1063,59,60,62,65,78,63,23,80,85,93,94,95,98,82,83,22,24,26,533,535,536,541,543,968,25,31,33,35,55,987,988,978,981,984,985,1038,1023,1025,137,408,138,418,14,15,21,13] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.298,0.702]
select surf_pocket2, protein and id [424,428,433,435,462,908,463,888,18,415,515,511,513,421,422,24,26,27,28,526,528,25,891,892,465] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.533,0.361,0.902]
select surf_pocket3, protein and id [316,317,318,314,315,313,291,292,293,258,263,169,171,172,173,175,243,170,188,168,333,336,223,224,225,226,227,228,155] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.565,0.278,0.702]
select surf_pocket4, protein and id [673,712,713,716,717,663,665,693,724,726,727,698,725,710,610,626,628,760,763,728,755,650,655,653,621,618] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.878]
select surf_pocket5, protein and id [426,18,413,415,513,427,428,429,430,432,433,405,338,340,342,503,505,358,460,478] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.533]
select surf_pocket6, protein and id [168,167,334,336,337,338,340,335,353,166,426,412,413,151,152,153,420,427,429,143,142] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.490]
select surf_pocket7, protein and id [3,4,5,6,394,396,400,406,408,127,128,118,124,125,9,11,13,85,98] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.329,0.278]
select surf_pocket8, protein and id [43,41,46,48,38,833,835,820,834,836,838,853,578,560,563] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.620,0.361]
select surf_pocket9, protein and id [168,167,353,166,183,140,142,163,143,151] 
set surface_color,  pcol9, surf_pocket9 
set_color pcol10 = [0.702,0.631,0.278]
select surf_pocket10, protein and id [358,361,363,362,386,389,390,383,396,397,398] 
set surface_color,  pcol10, surf_pocket10 
   
        
        deselect
        
        orient
        