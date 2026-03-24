
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
        
        load "data/structure_042.rebuilt.pdb", protein
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
 
        load "data/structure_042.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [145,426,17,18,20,411,428,413,427,8,10,510,506,511,513,515,149,151,420,421,423,425,153,143,403,405,430,431,433,435,429,432,923,953,448,903,522,524,27,28,30,529,534,535,531,526,528,907,908,910,962,886,887,888,891,889,890,911,912,913,340,358,332,333,334,335,336,353,170,338,165,167,168,169,171,172,173,183,186,187,243,213,223,348,224,225,227,242,228,241,203,189,190,205,318,321,322,323,325,473,478,475,503,504,505,481,482,464,465,483,317,315,538,966,969,970,963] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [653,736,738,728,727,731,733,753,754,759,760,717,718,719,720,726,744,745,749,750,751,655,659,661,610,660,662,663,664,665,666,618,761,763,698,688,694,695,696,697,699,700,671,673,672,712,639,641,642,644,645,646,648,636,637,638,743,626,627,629] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [1043,1025,1041,1042,1040,1045,1060,1061,1058,60,78,75,58,80,978,977,968,543,545,542,990,988,998,1038,981,986,1022,1023,1024,1026,1027,1039,15,22,23,24,533,13,1063,81,98,62,63,65,26,29,30,535,408] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [923,953,511,513,515,18,526,528,907,908,910,960,522,524] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [98,100,118,15,5,13,406,408,1,4,6,399,128] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        