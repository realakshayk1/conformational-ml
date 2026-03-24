
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
        
        load "data/structure_075.rebuilt.pdb", protein
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
 
        load "data/structure_075.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [412,413,426,427,428,15,411,145,410,409,144,406,403,513,515,509,510,405,420,422,424,151,153,147,149,425,431,433,436,437,430,432,438,18,953,343,342,477,478,460,476,357,358,502,503,338,143,353,321,322,323,337,339,340,341,335,356,320,318,319,168,28,17,528,526,956,959,961,963,26,27,31,35,442,875,446,885,903,923,447,462,463,439,440,458,888,904,906,907,908,887,910,928] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [12,22,25,531,533,13,97,98,120,100,118,10,1063,523,525,65,77,78,79,81,80,82,85,23,62,978,1043,1058,1061,1041,1042,1040,1045,970,543,988,60,73,1023,1025,1027,1039,1038,414,415,416,417,15,411,136,408,5,418] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [653,731,736,733,659,660,661,662,663,726,727,728,720,724,696,697,700,698,713,716,717,718,671,672,688,673,654,655,643,738,763] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [320,316,317,318,155,172,173,333,168,171,170,188,243,263,313,223,224,225,228,328,331,338,151,153,288,290,291,293,295] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [578,838,820,50,48,577,581,53,553,575,38,46,43,818] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        