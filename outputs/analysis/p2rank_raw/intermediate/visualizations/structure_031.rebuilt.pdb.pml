
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
        
        load "data/structure_031.rebuilt.pdb", protein
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
 
        load "data/structure_031.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [58,60,62,66,78,1025,1043,1061,1045,1063,533,534,536,539,540,541,978,63,543,46,29,31,35,40,30,85,80,93,94,95,96,97,98,79,81,82,83,988,980,985,1022,1023,13,22,26,12,11,523,415,418,25,421,422,23,24,423,27,408,405,3,5,9,118] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [908,907,923,430,435,27,28,433,886,887,888,889,890,903,906,875,463,18,20,513,527,515,953,511,538,528,31,33,891,893,879,880,530] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [338,325,339,340,341,342,343,358,503,505,353,320,318,458,460,477,478,322,323,15,18,413,427,428,153,432,431,433,143,403,405,10] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [155,169,171,172,173,175,263,170,180,188,226,228,225,230,243,245,244,246,247,189,190,193,213,315,320,333,336,338,293,316,317,318,152] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [694,695,696,697,698,725,716,717,719,720,724,726,727,731,733,626,763,728,736,653,655,660,663,738,618] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [855,877,878,879,854,856,858,880,32,33,36,37,38,41,45,837,838,840,853,562,563,556,559,561] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        