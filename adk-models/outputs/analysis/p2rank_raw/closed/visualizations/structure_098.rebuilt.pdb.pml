
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
        
        load "data/structure_098.rebuilt.pdb", protein
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
 
        load "data/structure_098.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [18,908,511,515,910,923,925,478,480,505,479,481,463,953,425,427,431,432,433,436,437,438,440,430,435,458,459,460,888,473,474,475,320,325,322,323,528,530,928,27,28,29,30,31,448,887,889,890,903,907,905,875,413,405,403,10,512,513,509,510,414,421,424,428,143,410,415,417,25,422,338,358,339,341,342,343,340,498,501,503,504] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [533,978,78,93,1043,95,986,1021,1023,1026,1025,1020,1024,1027,1063,1045,1058,1038,1041,1042,1040,62,55,58,61,64,65,73,74,76,75,987,989,990,996,998,1007,1008,1010,13,15,21,11,128,97,98,118,408,3,5,523,524,415,418,22,23,24,25,80,83,60,63,531,532,526,31,32,33,543,36,981,975,968,988] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [314,316,317,318,313,315,320,319,259,260,287,288,289,290,291,292,293,294,238,240,258,263,425,427,429,438,430,337,333,338,145,153,173,245,168,225,228,243,224,226,242,426,428] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [757,758,761,763,765,672,675,716,717,718,700,712,713,726,727,755,618,673,693,696,698,671,660,661,663,662,628] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [48,833,598,818,50,38,41,43,46,52,578,593,581,820,836,838,819] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [528,535,530,537,538,963,28,29,30,31,35,888,908,885,889,891,892,893,890,911,877,879,878,880] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [655,659,660,661,663,730,736,662,733,690,697,698,727,728,645,653,738,628] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [348,349,350,351,352,335,333,353,167,168,170,186,183,188,223,213] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        