
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
        
        load "data/structure_009.rebuilt.pdb", protein
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
 
        load "data/structure_009.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [13,1063,1025,1039,1041,1042,1043,1040,1045,1058,60,62,64,65,63,987,23,78,1023,80,85,97,98,99,100,101,115,118,76,77,81,82,83,79,73,74,75,1026,1027,1028,30,534,535,533,523,978,968,543,539,541,981,988,1038,406,408,130,3,5,120,128] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [435,433,462,463,478,464,465,953,903,888,923,425,428,430,18,413,505,511,513,538,963,907,908,910,35,873,889,890,891,892,893,895,904,905,906,875,25,28,536,528,530,31] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [426,427,428,431,18,413,15,505,511,513,503,432,458,433,477,478,459,460,405,411,403,144,145,146,147,149,150,143,155,166,151,153,168,333,337,340,353,356,357,358,167,317,319,320,318,321,322,325,338,323] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [616,663,664,665,693,696,697,669,671,672,655,653,654,656,660,618,720,763,713,716,717,718,719,628,724,726,727,728,731,698,725,736,733,611,614,673,615] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [38,820,836,837,838,555,46,48,43,579,580,578,41,42,565,583,562,818,817,598] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [293,242,245,314,315,317,316,318,313,172,173,333,243,225,223,155,153] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        