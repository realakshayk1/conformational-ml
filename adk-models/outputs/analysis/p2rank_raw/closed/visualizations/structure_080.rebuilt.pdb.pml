
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
        
        load "data/structure_080.rebuilt.pdb", protein
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
 
        load "data/structure_080.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [62,64,65,20,21,22,23,13,523,98,94,95,96,97,3,118,81,82,83,535,128,408,5,414,415,15,11,416,417,418,1043,1061,1063,60,78,1023,93,1025,543,978,533,1058,58,59,61,1022,988] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [478,493,503,505,506,509,510,320,322,325,428,338,477,462,463,460,464,465,476,474,475,323,143,337,339,340,341,342,434,435,431,432,433,923,903,904,906,446,447,14,15,17,18,411,412,413,511,513,515,953,145,427,409,410,405,875,28,888,528,907,908,526,910,887,905,16] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [330,315,317,320,328,331,153,314,173,243,245,224,225,240,242,263,293,313,256,257,258,316,312,318,168,169,170,171,186,188,213,222,223,155,332,333,335,348,351,352,353] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [820,838,817,818,578,47,48,580,598,38,555,53,560,562,41,42,43,44,46,833,853,834,835,836,837] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [673,713,717,672,675,692,693,698,763,761,762,718,719,721,663] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [36,39,40,41,43,25,875,31,32,878,855,852,853,873] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [654,655,728,730,738,733,656,660,662,663,688,697,698,653] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        