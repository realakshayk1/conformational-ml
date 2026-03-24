
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
        
        load "data/structure_056.rebuilt.pdb", protein
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
 
        load "data/structure_056.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1023,78,1025,1041,1043,1039,1042,1058,1044,1045,1059,1061,1068,1040,1046,1047,58,73,76,977,968,970,974,975,543,542,978,986,987,990,1038,1022,533,13,523,525,1060,1063,1064,1065,60,62,65,21,23,79,85,80,94,96,97,98,100,3,1066,1067,118,81,82,83,529,530,408,128,405,14,15] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [14,15,17,18,8,11,513,515,509,510,504,506,145,421,422,426,413,428,436,437,430,431,433,434,435,432,463,953,950,505,923,903,905,875,409,143,403,404,410,405,402,398,385,320,322,323,325,343,477,478,502,503,493,460,474,476,475,338,339,340,342,358,21,29,30,26,27,535,888,28,537,890,526,528,961,962,963,966,907,908,928,889,891,892,906,913,970,538] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [167,172,173,188,215,221,222,226,224,183,186,213,168,332,333,335,348,351,352,353,314,315,316,317,318,313,330,331,320,329,263,243,293,292,294,295,152,153,155] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [35,37,48,41,43,44,46,820,833,817,853,837,838,836,818,578,580,562,38] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [82,83,85,98,103,148,136,137,138,141,408,134,135,414,415,416,418] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [730,727,728,698,659,660,661,663,662,654,655,645,653,740] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        