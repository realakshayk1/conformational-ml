
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
        
        load "data/structure_006.rebuilt.pdb", protein
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
 
        load "data/structure_006.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [15,413,18,428,432,433,953,507,513,950,535,28,30,531,528,959,961,963,954,955,427,429,29,430,534,538,973,970,340,478,505,503,325,337,338,435,888,903,923,948,890,895,906,908,907,910,875,887,889,891,892,893,463,459,460,462,465,483,447,9,10,405,412,410,403,8,401,143,358] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [82,98,128,408,11,13,3,96,97,100,95,118,416,418,63,65,81,83,5,400,62,60,78,1058,1042,1043,1045,1063,1041,79,80,1023,1024,1025,1039,1040,534,536,539,540,541,968,33,35,543,978,27,23,533,535,26,523,417,419,423,29,31] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [155,291,292,293,296,300,318,317,332,333,316,227,230,310,313,243,224,225,314,315,261,262,263,246,247,248,157,158,298,175,176,228,177,178,193,173] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [423,425,31,28,30,37,38,32,34,35,36,41,873,874,855,876,877,875,893,435,853,854] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [731,725,727,728,628,618,762,763,626,627,656,659,660,653,654,655,663,698,710,715] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [875,889,891,892,893,890,873,874,435,888,28,30,425,29,31,538,32,36] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        