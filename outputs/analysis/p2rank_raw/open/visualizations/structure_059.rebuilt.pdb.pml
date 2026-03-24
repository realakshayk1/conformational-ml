
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
        
        load "data/structure_059.rebuilt.pdb", protein
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
 
        load "data/structure_059.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [141,142,143,145,403,383,401,385,154,156,150,151,152,153,431,432,433,458,460,478,503,295,436,438,337,339,341,353,354,355,356,357,358,155,167,168,293,318,319,338,320,473,475,477,476,340,343,325,321,322,427,428,15,18,413,513,420,425,426,405,429] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.365,0.278,0.702]
select surf_pocket2, protein and id [82,83,86,80,97,98,1062,1063,99,100,101,115,113,87,138,130,404,406,407,408,103,128,405,3,13,118,30,20,22,23,531,533,523,12,14,518,77,1023,1025,1027,1030,1040,1042,1043,1045,1061,58,78,978,981,968,975,1058,60,987,540,985,984] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.792,0.361,0.902]
select surf_pocket3, protein and id [435,31,27,28,538,888,889,890,891,892,528,906,907,908,910,953,960,922,923,949,948,950,868,430,35,872,873,903,904,905,869,870,427,428,18,413,513,25,422,426,431,432,433,462,463,458,460,461,511,478,483,465,437,439,440] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.533]
select surf_pocket4, protein and id [315,333,316,308,311,313,314,242,245,262,263,258,239,240,241,243,238,225,292,293,296,317,318,285,288,291,280,155,160,173,157,158,159] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.361]
select surf_pocket5, protein and id [663,670,696,698,628,653,655,733,731,724,763,721,725,716,717,726,727,728,618,673] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.533,0.278]
select surf_pocket6, protein and id [578,581,562,563,838,565,579,38,555,46,48,593,41,43,853,834,835,837,833,790,792,817,818,820,598] 
set surface_color,  pcol6, surf_pocket6 
   
        
        deselect
        
        orient
        