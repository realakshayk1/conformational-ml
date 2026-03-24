
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
        
        load "data/structure_016.rebuilt.pdb", protein
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
 
        load "data/structure_016.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [79,78,978,80,1043,1025,1058,1040,1041,1042,1045,1061,1062,1044,1063,62,63,55,58,60,988,984,985,1038,1022,1023,418,23,65,13,14,15,16,19,21,22,533,523,82,408,85,97,98,99,100,101,3,118,102,83,405,5,130,26,30,541,542,534,535,536,539,530,968,543,981,20] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [142,143,416,413,405,403,141,133,135,150,420,15,11,168,353,337,339,340,356,357,358,354,382,383,355,385,163,164,165,166,342,318,320,338,325,341,476,477,478,503,460,458,428,430,431,433,18,510,513] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [18,20,510,511,513,528,509,950,953,430,431,433,435,25,28,904,906,907,908,923,888,890,889,891,892,463,462,538,478,507,508,465,415,19,21,413] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [155,172,173,168,353,333,337,188,225,243,332,223,258,259,260,242,149,150,151,152,153,143,314,315,317,318,338,293,238,312,313,222,328,329,330,331,285,291,292,240,428] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        