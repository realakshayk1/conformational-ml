
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
        
        load "data/structure_088.rebuilt.pdb", protein
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
 
        load "data/structure_088.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [76,78,79,80,82,83,67,73,98,1043,1045,1061,1063,1064,1066,1042,85,93,94,95,96,97,61,62,58,63,64,66,533,978,523,1058,535,541,977,31,35,543,40,981,1038,1037,1039,1040,988,984,985,1023,1022,1020,1025,1036,1041,136,137,138,140,408,134,135,3,13,100,118,15,22,525,418,420,23] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [435,873,28,528,907,908,953,888,890,891,906,872,18,415,20,513,892,893,876,877,878,548,38,852,853,854,856,30,534,535,538,530,970,29,32,33,34,35,36,37,39,41,463] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [348,218,221,213,203,168,332,333,167,349,350,171,172,183,186,188,315,328,329,330,331,223,313,173,224,225] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [662,663,666,669,670,690,712,715,725,726,727,731,733,696,698,710,645,653,655,626,628,763,755,643,753,728] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [840,834,835,836,837,838,818,38,853,856,41,43,48,578,598,562,563,579,580,555] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [502,503,428,403,401,8,512,513,16,17,18,413,404,405] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [143,144,145,147,149,151,152,150,154,155,168,333,335,353,427,428,153,425,412,413,410] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [136,137,138,408,134,135,13,128,99,100,101,102,103,127,129,131,132,98,82,83,85] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        