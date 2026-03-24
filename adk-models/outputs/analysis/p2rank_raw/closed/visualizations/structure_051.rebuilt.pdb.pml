
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
        
        load "data/structure_051.rebuilt.pdb", protein
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
 
        load "data/structure_051.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [411,413,421,428,409,142,143,144,18,511,513,524,525,509,510,8,403,404,405,406,515,507,151,153,423,425,149,150,337,338,340,354,355,356,357,358,500,502,503,506,320,322,333,334,335,336,168,145,353,170,432,433,434,435,436,429,430,463,908,905,321,323,460,476,478,480,481,458,461,462,465,528,888,928,28] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [22,23,541,542,543,533,978,77,78,79,80,81,82,93,98,99,62,60,65,63,1023,987,988,1025,1043,1040,418,103,138,140,83,135,408,101,13,15] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [696,698,715,712,713,714,722,610,671,672,673,675,655,630,656,659,660,661,663,648,653,738,729,730,628,629,633,761,763,636,753,741,745,726,727,728,616,618,638] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [63,42,46,53,62,60,65,23,543,78,418,419,420,26,34,36,37,41,43,27,29,30,31,32,33,38] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [321,323,473,460,476,303,458,461,462,301,302,318,290,432,434,436,429,430,438,445,443,319,425] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [1061,1063,118,78,80,93,98,95,23,533,1043,5,128,13,15,3,408] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [173,174,175,188,193,263,177,224,225,226,228,246,315,290,260,286,287,289,292,293,262,243,313,314,316,318] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [330,332,333,218,219,220,315,348,353,221,222,223,224,213,173,170,186,188,187,349,350] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        