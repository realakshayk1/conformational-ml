
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
        
        load "data/structure_010.rebuilt.pdb", protein
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
 
        load "data/structure_010.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [95,97,98,20,531,533,523,118,23,30,82,83,85,103,80,13,405,408,128,3,418,138,410,543,544,546,540,77,78,79,74,75,93,1045,1063,1042,1043,1047,970,974,976,968,61,58,59,60,65,73,978,1024,1025,1026,1027,1028,1023,1010,550,985,987,988,549] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [428,431,432,434,150,163,141,142,143,145,139,140,133,403,382,385,501,502,503,505,478,320,336,337,338,339,340,341,164,165,166,167,168,353,183,352,499,342,495,358,383,318,493,15,411,405,409,135,413,433,410,460,435] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [18,513,525,953,413,429,430,433,28,528,524,959,960,530,963,25,27,511,503,505,507,478,428,431,432,538,903,923,890,907,908,888,463,889,462,465,892] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [152,153,155,171,173,172,293,313,315,331,332,333,168,314,317,318,225,238,242,243,245,223,328,329,188,258,260,262,263] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [25,27,31,32,28,430,433,35,33,872,873,875,891,893,892,871,888,889,890] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [40,48,38,61,63,58,59,60,543,544,545,546,33,553,988,550,985,987,578,549,551,36] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [503,505,510,403,15,18,513,405,8,413] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [618,663,716,719,720,763,717,718,696,698,672,673,670,675,693] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        