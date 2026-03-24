
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
        
        load "data/structure_007.rebuilt.pdb", protein
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
 
        load "data/structure_007.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [15,17,18,511,513,515,505,153,426,427,25,413,403,385,143,146,383,151,149,428,431,432,435,440,429,430,433,465,953,908,478,888,462,463,903,890,464,904,905,923,970,28,535,538,528,530,963,910,31,873,32,33,36,891,892,893,895,907,909,911,912,872,913,503,353,338,340,356,357,358,168,325] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [65,78,79,80,81,82,83,85,98,1058,1065,1043,1045,1062,1063,100,97,113,116,118,541,20,533,534,536,523,525,968,61,23,63,543,62,539,1025,1024,1042,1041,58,55,1023,984,985,975,978,987,13,405,10,12,2,3,407,408,128,19] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [188,328,331,332,333,245,263,242,243,239,240,258,314,312,313,316,317,225,238,223,290,293,318,265,260,262,170,171,172,173,153,155] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [596,838,565,576,577,578,579,580,581,582,583,598,818,573,554,555,560,561,562,593,40,46,48,833,834,835,836,837,840,45,816,817,819,820] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [755,725,727,728,731,733,662,663,762,763,660,698,715,628,653] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [145,410,414,407,408,13,138,148,418,415,19,83,85,98,67,68,70,23,20,533] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [353,356,357,378,381,140,133,383,143,352,368] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [37,41,31,873,32,34,35,853,871,872,435,440,867,868,869,420] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        