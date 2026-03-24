
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
        
        load "data/structure_055.rebuilt.pdb", protein
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
 
        load "data/structure_055.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [427,428,429,431,432,430,433,435,462,465,950,953,908,536,970,528,963,28,538,893,463,890,892,895,904,905,906,907,923,913,322,323,458,325,476,477,478,479,481,482,483,318,319,321,18,511,513,515,420,426,413,145,405,143,507,509,510,505,506,403,151,153,25,20,524,525,335,320,334,337,338,340,503,353,356,358,168] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [1041,1042,1043,1045,1063,65,60,73,76,81,82,83,79,80,78,96,97,98,99,100,101,118,86,103,26,13,22,23,533,523,543,978,545,980,968,52,54,63,55,62,30,1023,1025,1007,1008,990,1000,987,988,985,981,1038,145,138,140,148,408,411,137,139,3,5,6,128,416,418,9,10,144] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [36,38,39,40,833,834,835,836,837,838,559,560,561,562,553,555,578,46,41,43,51,32,53] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [171,172,173,175,242,243,245,335,315,332,333,169,170,188,228,263,261,293,318] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [34,35,546,547,540,36,38,551,553,555,31,32,53] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        