
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
select surf_pocket1, protein and id [78,19,20,21,22,23,24,533,523,13,1058,64,65,59,60,62,63,1025,1038,1000,978,985,1023,56,58,1043,1042,1045,1063,95,82,83,85,96,97,98,99,101,118,103,1041,404,406,408,10,12,6,9,11,136,137,134,135,128,3,5,400,138,29,26,30,532,534,543,541,542,970,968,969,33,987,974,976,977,975] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.490,0.278,0.702]
select surf_pocket2, protein and id [317,318,321,316,319,322,323,325,338,343,503,505,168,336,333,334,335,143,188,337,340,341,353,155,171,170,172,173,175,243,315,314,224,225,313,227,189,190,228,242,258,435,300,320,478,457,458,477,285,290,293,428,427,430,431,432,434,18,433,151,153,145,413,405,513] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.682]
select surf_pocket3, protein and id [421,428,430,18,433,511,515,953,27,28,538,527,528,463,887,888,462,903,923,891,892,893,895,904,905,906,907,908,873,513,413,25,478,461,505] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.408,0.278]
select surf_pocket4, protein and id [620,661,663,763,727,761,717,719,720,725,726,728,762,626,628,755,653,655,618] 
set surface_color,  pcol4, surf_pocket4 
   
        
        deselect
        
        orient
        