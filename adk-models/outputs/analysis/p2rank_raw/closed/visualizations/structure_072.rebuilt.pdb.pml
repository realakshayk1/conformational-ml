
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
        
        load "data/structure_072.rebuilt.pdb", protein
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
 
        load "data/structure_072.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [65,76,78,81,82,83,79,80,1063,93,96,97,98,115,118,85,25,22,23,533,523,1060,61,62,415,15,10,13,408,128,120,3,74,75,73,1022,1024,1025,1041,1042,1043,1045,1047,1058,1039,1059,1023,1008,543,977,978,981,988,990,58] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [26,888,907,908,910,923,883,884,887,905,906,903,440,870,875,881,17,18,513,515,419,420,422,21,415,30,27,28,528,425,426,436,437,438,431,432,433,435,428,475,478,505,448,463,446,413,503,509,510,511] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [413,403,405,502,503,506,510,401,143,145,151,152,153,424,425,426,427,430,433,428,475,478,337,325,338,339,341,342,343,353,354,356,357,358,168,319,320,321,322,18] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [430,438,432,428,475,478,441,443,453,457,458,459,290,303,460,473,474,318,321,322,323] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [170,186,187,188,333,331,168,348,213,223,224,225,226,328,315,317,243,155,167,173] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [243,258,292,293,245,261,262,259,318,313,315,317,263,173] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        