
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
        
        load "data/structure_007.rebuilt.pdb", protein
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
 
        load "data/structure_007.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [533,1043,540,968,1044,1045,1063,1025,978,13,23,19,20,22,532,523,410,408,12,6,11,93,96,97,98,1027,100,128,4,2,3,118,5,58,59,60,61,62,543,83,78,79,81,80,82,1023,988,418,30,26,530,542,539] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [28,27,31,35,535,538,528,908,963,970,907,969,973,426,427,437,18,429,430,431,433,434,435,462,463,953,950,923,507,508,511,422,423,424,425,438,465,505,478,875,888,891,892,893,890,903,904,905,906,873,15,413,512,513] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [428,18,429,430,431,432,462,463,153,438,155,288,318,319,320,321,302,458,460,478,295,443,301,303,15,411,413,403,513,143,145,152,338,339,340,341,342] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [743,745,731,733,736,738,741,751,728,725,727,710,622,654,655,656,657,619,620,659,661,624,618,763,663,696,698,700,716,712,626,628,653,753] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [333,334,335,336,337,338,173,145,150,152,168,293,317,318,320,314,315,316,153,155] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [142,143,145,150,152,413,168,333,334,335,336,337,338,317,320,428,153,155] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        