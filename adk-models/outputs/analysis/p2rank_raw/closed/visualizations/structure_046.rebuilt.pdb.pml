
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
        
        load "data/structure_046.rebuilt.pdb", protein
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
 
        load "data/structure_046.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [15,17,18,413,8,511,513,515,415,417,421,422,423,424,426,428,405,410,439,440,425,438,436,437,431,908,907,923,448,906,903,29,30,31,26,27,534,535,28,528,910,963,32,34,35,36,39,40,887,888,909,911,875,877,879,878,880,63,21,23,24,429,430,338,432,433,509,510,476,477,478,501,502,503,506,434,445,447,463,465,320,323,343,473,474,475,403,358,143,341,342,355,538,970,60] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.616,0.278,0.702]
select surf_pocket2, protein and id [1043,1042,1058,1045,1061,1068,58,61,988,71,73,76,78,93,1023,543,541,542,978,974,968,971,975,59,60,990,62,63,64,65,66,22,23,25,533,523,530,13,1063,82,80,97,98,1065,95,118,83,81,958,128,408,3,5,415,417] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.361]
select surf_pocket3, protein and id [316,317,320,328,331,224,225,243,245,263,293,295,313,258,259,260,153,318,338,171,188,172,173,333,334,336,226,223,151,152,168] 
set surface_color,  pcol3, surf_pocket3 
   
        
        deselect
        
        orient
        