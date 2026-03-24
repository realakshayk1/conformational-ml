
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
        
        load "data/structure_085.rebuilt.pdb", protein
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
 
        load "data/structure_085.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [12,13,1058,1060,1063,3,59,60,63,78,29,21,22,23,534,541,16,529,531,533,520,523,33,61,55,57,30,545,81,82,83,93,94,96,97,98,95,118,101,410,408,5,11,128,130,137,138,15,417,418,1042,1025,1043,1040,1045,543,978,980,977,975,1023,542,985] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [28,536,537,538,888,528,908,963,964,965,909,30,548,892,894,895,911,890,887,889,891,532,525,527,969,970,20,534,535,434,435,463,906,907,903,430,432,433,18,513,971] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [625,655,653,727,728,738,729,631,638,641,643,628,761,762,763,764,756,759,743,753,754,618,731,721,722,725,755,758,760,610,659,660,661,662,664,665,671,673,698,715,690,695,697,700,672,688] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [413,430,433,506,428,431,405,143,144,145,500,503,338,320,323,340,478,358] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [334,337,353,356,355,358,168,333,336,338,320,142,144,145,146,147,149,150,151,143,414,421,426,428,413,423,153] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [167,168,169,188,170,186,187,214,211,213,190,203,334,335,350,353,348,215,333,336,223,150] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [172,173,243,313,225,333,317,320,290,168,169,171,188] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        