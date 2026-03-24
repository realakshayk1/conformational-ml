
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
        
        load "data/structure_097.rebuilt.pdb", protein
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
 
        load "data/structure_097.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [428,143,502,503,403,429,430,460,478,477,447,448,462,463,500,338,340,357,358,420,426,18,413,431,16,17,513,953,510,15,412,14,405,411,424,437,432,433,435,888,908,923,903,28,528,31,25,27] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.298,0.702]
select surf_pocket2, protein and id [1038,1023,1024,1025,1026,1042,1043,1045,1058,61,78,73,58,59,60,539,540,541,542,985,978,968,55,543,990,1020,1008,65,81,13,1063,20,22,533,534,535,63,23] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.533,0.361,0.902]
select surf_pocket3, protein and id [65,81,82,83,13,1063,80,85,94,96,97,98,100,118,19,20,21,22,533,63,23,416,417,15,408,418,130,128,3,5,93,1043,1045,1058,78] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.565,0.278,0.702]
select surf_pocket4, protein and id [142,144,145,151,153,143,154,155,163,166,168,171,173,318,333,340,353,357,358,320,336,337,338,146,147,140] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.878]
select surf_pocket5, protein and id [145,151,153,428,143,429,430,460,458,318,320,321,322,323,336,337,338,427,425,438,432] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.533]
select surf_pocket6, protein and id [313,243,314,315,317,320,290,292,293,291,258,170,188,333,172,173,318,288,262,263,287] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.490]
select surf_pocket7, protein and id [318,288,430,441,443,458,301,302,303,290,299,321,322,323,438] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.329,0.278]
select surf_pocket8, protein and id [671,660,690,662,663,727,725,716,719,720,696,692,694,695,697,699,672,689,691] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.620,0.361]
select surf_pocket9, protein and id [333,223,351,353,348,170,228,183,184,186,188,212,213,214,215,226,211,167,168,169] 
set surface_color,  pcol9, surf_pocket9 
set_color pcol10 = [0.702,0.631,0.278]
select surf_pocket10, protein and id [18,413,16,17,513,510,15,412,14,405,411,11,8,503] 
set surface_color,  pcol10, surf_pocket10 
   
        
        deselect
        
        orient
        