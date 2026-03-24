
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
        
        load "data/structure_005.rebuilt.pdb", protein
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
 
        load "data/structure_005.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [422,424,425,427,428,429,430,431,432,412,411,413,143,145,410,409,511,512,513,505,10,8,405,151,152,153,154,155,173,423,263,320,321,322,323,315,317,318,314,316,478,337,338,334,336,333,503,171,172,227,228,168,169,243,241,242,223,224,225,226,313,238,25,27,21,15,18,528,953,529,531,534,535,536,970,28,31,433,434,436,438,435,437,888,890,905,923,907,908,910,911,463,460,465,476,441,458,303,305,301,302,288,291,292,293,295,296,298,443,889,891,892,895,538,963,913] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.616,0.278,0.702]
select surf_pocket2, protein and id [533,539,540,1043,97,98,99,100,1058,1063,1045,968,58,60,59,61,62,65,78,81,82,83,80,541,542,543,1041,1042,1023,1027,1025,985,978,23,415,418,19,20,408,14,15,523,5,3,13,118,411,138,128] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.361]
select surf_pocket3, protein and id [655,663,763,727,728,731,724,725,653,660,698] 
set surface_color,  pcol3, surf_pocket3 
   
        
        deselect
        
        orient
        