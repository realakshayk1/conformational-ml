
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
        
        load "data/structure_035.rebuilt.pdb", protein
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
 
        load "data/structure_035.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [58,75,78,79,80,81,82,93,23,33,540,543,545,533,535,97,1043,1059,1060,1062,1063,1058,970,523,63,61,62,65,51,56,44,978,1025,1041,1038,1023,988,990,26,27,28,415,416,417,418,421,31,424,425,429,430,431,83,15,18,21,13,407,408,5,11,98,118,1,3,45,422,423,35,435,437] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [152,153,172,173,318,149,150,168,428,432,144,145,477,478,319,320,333,317,315,321,322,323,336,337,338,353,476,243,225,313,170,245,263,260,262,193,156,412,426,431,413,443,295,433,454,456,457,458,455,301,302,303,473,285,287,288,290,291,292,293,438,441] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [10,18,413,528,510,512,513,953,511,28,431,506,529,534,536,537,538,530,25,29,30,878,880,887,905,908,920,924,926,903,435,447,448,888,927,928] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [653,641,728,638,753,726,727,720,724,754,755,654,633,661,662,663,620,761,763,664,665,666,671,698,714,731,697,700,719,725,710,688,636] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [143,358,403,401,340,338,10,413,510,512,513,8,406,409,410,411,412] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        