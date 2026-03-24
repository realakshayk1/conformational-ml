
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
        
        load "data/structure_014.rebuilt.pdb", protein
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
 
        load "data/structure_014.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [527,528,526,530,963,908,882,884,886,889,891,892,928,911,912,913,929,931,932,520,959,960,961,30,25,18,448,888,903,905,478,461,462,466,467,445,513,515,921,923,480,437,440,435,433,434] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [29,31,32,33,34,36,55,543,23,26,27,541,542,546,28,54,56,52,590,591,592,593,40,63,59,60,61,30,535,537,538,551,553,573,992,993,982,547,549,550,556,560,989,990] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [6,9,10,13,408,20,1063,1045,1058,1059,1065,1043,1057,1060,535,533,63,78,415,33,543,23,542,93,95,94,96,3,98,113,407,411] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [63,73,78,60,543,23,542,1045,1058,1065,1043,978,1057,535,974,976,533,975,93,95,94,96,98,988,1023,990,1024,1026] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [176,188,190,172,173,243,295,258,226,228,238,193,246,247,242,330,331,332,333,334,338,329,316,317,328,314,318,222,223,312,313] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [15,512,513,505,478,431,413,432,433,436,440,458,143,410,341,342,322,473,476,477,339,340,335,337,338,321] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [438,441,458,442,443,436,317,303,318,321,457,293] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        