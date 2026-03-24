
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
        
        load "data/structure_049.rebuilt.pdb", protein
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
 
        load "data/structure_049.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [13,1063,1025,1040,1041,1042,1043,1045,58,60,62,65,73,76,83,78,81,1023,85,97,98,101,103,80,118,93,82,79,23,533,523,525,543,987,542,977,978,981,1058,968,55,988,990,985,1038,1007,408,410,3,4,5,6,130,136,128] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [15,18,413,8,513,502,503,151,428,152,153,412,403,405,401,149,150,143,320,325,337,338,339,340,341,353,354,355,358,168,427,431,432,433,478,460,505,318,322,323,477] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [430,433,435,478,465,908,953,505,528,963,28,463,888,903,923,904,905,906,907,910,890,892,893,895,18,413,511,513,514,515,521,526] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [726,697,698,715,720,725,731,733,701,663,695,626,653,655,727,728,620,763] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [173,243,333,241,224,225,223,245,155,153,291,293,317,318,313,314,316] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        