
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
        
        load "data/structure_034.rebuilt.pdb", protein
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
 
        load "data/structure_034.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [523,525,1058,13,1059,1060,1061,64,65,55,59,60,61,62,63,22,23,24,26,535,533,25,31,36,38,40,543,53,83,76,78,79,81,82,80,1043,3,1045,1062,1063,94,96,93,85,97,98,103,118,72,73,1023,1025,1041,1040,1042,987,988,977,978,980,990,417,15,418,408,410,5,1,128,129,130,137,138,140,148] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [145,428,412,413,411,405,151,425,431,432,433,478,429,430,143,403,333,336,338,503,353,340,358,320,322,476,473] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [435,431,432,433,478,463,465,953,907,445,903,906,447,448,18,413,415,515,511,513,887,888,890,908,28,526,528,961,476] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [660,661,665,720,663,664,666,671,715,716,717,719,672,674,675,696,726,727,731,697,698,673,653,628,635,760,763,728] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [173,243,188,332,333,331,223,313,315,320,328] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [168,171,173,183,185,186,187,188,190,335,348,351,352,332,333,330,331,223,226,228,205,207] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        