
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
        
        load "data/structure_013.rebuilt.pdb", protein
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
 
        load "data/structure_013.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [426,427,428,429,430,431,435,432,433,463,28,29,30,31,534,535,32,536,538,970,973,950,953,923,948,528,908,530,966,971,963,964,965,448,888,903,889,891,892,893,890,904,905,895,906,907,911,875,18,19,21,411,413,24,531,405,135,404,8,11,511,513,401,529,153,25,507,508,510,339,340,342,343,478,503,505,358,403,385,320,335,337,338,143,345,462,460,464,465] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [985,978,1038,93,1025,1027,1043,1028,1023,13,15,19,21,20,22,23,533,410,80,97,98,94,96,100,408,128,523,1063,1042,1044,1046,1060,1059,968,1058,118,10,62,66,78,83,77,79,81,82,45,63,58,60,543,418,35,30,534,535,541,970,540,530,969] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [422,37,38,40,41,42,43,578,35,36,31,32,425,428,27,28,873,874,875,876,877,878,880,835,853,854,855,563,838,45,420,25] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [618,664,665,620,659,660,663,733,763,725,727,728,731,698,712,713,716,671,628,626,653,654,655] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [425,428,431,435,432,433,27,28,36,29,31,873,874,875,877,880,891,888] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [152,154,155,157,168,173,336,317,318,320,333,334,335,337,338,143,228,315,313,243,293,295,151,153] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        