
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
        
        load "data/structure_072.rebuilt.pdb", protein
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
 
        load "data/structure_072.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [18,460,478,510,505,507,511,512,513,950,425,427,431,433,436,437,25,20,28,535,908,527,528,953,30,887,888,891,892,903,905,907,911,923,948,924,926,445,446,450,462,463,464,465,483,869,871,872,873,439,440,442,444,447,870,413,415,7,8,538] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [78,1010,1023,1025,1042,1043,1045,1038,1058,536,968,970,55,58,543,539,541,987,986,976,978,14,16,21,408,10,12,13,520,523,1063,97,98,99,100,118,113,85,102,94,95,101,61,81,82,83,410,406,2,6,3,128,418,23,19,531,533,534,525] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [293,318,338,280,168,169,170,171,172,173,243,241,242,313,314,333,315,188,335,227,228,222,226,238,223,423,438,426,428,430,435,155,160,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [142,15,412,413,143,411,405,5,401,403,396,397,399,18,478,510,505,340,353,355,356,357,358,390,383,385,338,502,503,493,339,354,342] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [66,67,68,63,62,64,65,158,418,421,148,423,422] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        