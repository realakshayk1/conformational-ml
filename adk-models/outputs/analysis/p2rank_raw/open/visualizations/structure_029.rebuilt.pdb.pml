
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
        
        load "data/structure_029.rebuilt.pdb", protein
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
 
        load "data/structure_029.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [60,63,65,78,23,1063,80,93,96,97,98,101,85,532,533,536,970,523,968,30,541,1025,1042,1043,1045,978,57,56,543,1022,1023,987,989,990,540,974,976,975,550,406,407,408,3,4,5,13,128,130,400,118,120] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [420,426,431,153,427,430,428,433,18,477,478,513,515,525,502,503,504,505,479,953,412,413,415,143,416,144,145,146,147,149,150,152,318,319,320,321,322,323,338,340,341,358,527,528,28,538,35,434,436,462,463,888,458,465,483,473,474,476,890,892,908,873,893] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [333,188,334,336,337,338,340,358,353,356,357,172,173,175,243,245,242,263,318,315,317,320,314,316,313,258,261,262,222,223,238,240,241,226,144,146,150,413,143,152,168,178,155,285,293,287,291,292,294,295] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [50,48,578,555,818,580,38,41,43,44,45,46,838,562,563,840,835,836,837,820] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        