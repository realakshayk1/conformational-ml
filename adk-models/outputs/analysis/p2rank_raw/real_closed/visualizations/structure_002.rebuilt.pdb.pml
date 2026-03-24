
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
        
        load "data/structure_002.rebuilt.pdb", protein
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
 
        load "data/structure_002.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [543,536,539,540,542,968,969,970,23,533,523,60,78,59,61,97,100,1063,79,80,81,82,83,98,118,1043,1042,1044,1045,1046,1047,1048,1023,1025,1027,978,981,984,985,1058,58,15,11,13,408,128,3,415] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.298,0.702]
select surf_pocket2, protein and id [18,413,431,432,433,513,953,511,887,888,462,463,890,905,906,907,908,923,903,428,435,143,460,465,478,505,320,325,338,340,28,528,892] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.533,0.361,0.902]
select surf_pocket3, protein and id [592,593,595,573,575,58,990,992,995,553,1008,666,667,668,682,683,684,686,688,1002,1004,1006,78,49,50,52,56,65,51,47,48,73,660,662,77,74,75,76] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.565,0.278,0.702]
select surf_pocket4, protein and id [172,173,243,293,296,291,292,225,227,230,238,313,300,316,317,318,314,320,315,333,171,228,155,157,285,287,153,425,438] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.878]
select surf_pocket5, protein and id [418,421,423,422,435,424,425,873,437,18,430,431,888,68,63,65,40,32,33,34,35,36,39,42,25,27,28,29,31,43] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.533]
select surf_pocket6, protein and id [158,848,851,833,835,421,423,422,852,853,41,42,63,43] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.490]
select surf_pocket7, protein and id [653,727,728,731,763,725,618,619,620,655,659,660,663,715,697,698,733,673] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.329,0.278]
select surf_pocket8, protein and id [836,43,44,45,837,838,820,578,817,818,792,598,795,41,565,581,582,833,790] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.620,0.361]
select surf_pocket9, protein and id [158,418,421,423,422,148,163,43,68,63,42] 
set surface_color,  pcol9, surf_pocket9 
set_color pcol10 = [0.702,0.631,0.278]
select surf_pocket10, protein and id [613,48,71,73,658,660,662,665,664,666,667,668,595] 
set surface_color,  pcol10, surf_pocket10 
   
        
        deselect
        
        orient
        