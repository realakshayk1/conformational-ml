
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
        
        load "data/structure_005.rebuilt.pdb", protein
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
 
        load "data/structure_005.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1043,13,1058,1045,1061,1062,1064,1065,59,60,61,65,78,30,19,20,23,525,535,541,543,533,978,33,53,96,97,98,99,101,93,102,103,92,94,95,100,120,1063,118,79,81,82,1041,1022,1025,1042,134,135,408,410,1,3,5,128,130,138,15,414,415,416,418] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [316,317,318,321,322,323,473,474,476,477,289,290,312,313,245,260,168,333,353,328,336,337,338,339,340,341,169,171,173,188,243,258,225,151,425,426,153,427,428,429,430,431,503,149,150,145,436,438,441,458,432,460,478,475,287] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [433,448,463,465,907,904,905,906,953,923,440,435,903,875,430,431,18,513,509,511,514,515,505,507,528,908,28,888,887,526,527] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [653,643,660,661,662,663,655,628,763,724,726,728,755,727,731,618,672,675,715,722,698,719,720,725,666,690,664,696,699,700] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [30,31,23,541,543,32,33,53,59,60,61,36,547,40,538,546] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        