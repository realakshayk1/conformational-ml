
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
        
        load "data/structure_088.rebuilt.pdb", protein
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
 
        load "data/structure_088.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [12,13,16,19,20,531,1058,532,533,536,969,1059,1060,1063,520,523,525,966,62,63,67,75,81,83,78,23,542,543,59,60,61,54,55,56,33,34,541,545,39,40,36,577,598,53,79,82,102,103,93,94,96,97,98,99,100,95,113,3,990,978,1028,1043,1045,1030,1044,1046,1047,1048,593,410,415,135,10,408,406,404] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.616,0.278,0.702]
select surf_pocket2, protein and id [142,150,427,428,143,431,432,436,425,411,413,435,438,437,440,443,11,407,8,14,15,17,18,513,516,433,510,478,903,461,462,466,463,467,885,908,905,907,511,953,505,923,406,404,405,153,152,25,528,526,521,522,524,910,960,963,316,317,333,336,338,325,335,341,322,324,477,474,475,318,320,321,323,458,460,473,481,353,340,358,339,225,169,170,171,175,293,172,292,295,185,188,243,228] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.361]
select surf_pocket3, protein and id [818,800,803,602,45,52,580,582] 
set surface_color,  pcol3, surf_pocket3 
   
        
        deselect
        
        orient
        