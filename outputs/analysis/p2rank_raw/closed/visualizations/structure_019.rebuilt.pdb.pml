
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
        
        load "data/structure_019.rebuilt.pdb", protein
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
 
        load "data/structure_019.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [63,62,66,80,78,520,13,98,99,100,94,95,118,77,81,23,525,15,411,405,408,6,9,128,3,398,418,415,138,1042,1043,1058,1045,1062,1063,60,73,75,93,533,978,968,543,988,1039,1025,1028,1041,1023,987,990,981,985] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [143,428,140,501,502,503,507,508,509,510,430,437,438,432,434,460,465,477,478,480,505,479,948,448,463,464,483,439,319,320,321,322,323,325,337,338,341,340,358,421,440,872,18,431,433,435,887,888,513,515,949,950,953,511,905,908,922,923,422,409,410,411,413,406,407,8,31,19,25,27,28,535,20,528,530,960,35,889,890,873,874,875] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [315,317,319,320,321,333,334,336,322,337,338,230,245,263,243,244,247,290,287,348,350,353,340,170,183,187,188,200,193,228,168,155,171,172,173,176,177,288,152,153,150,154,156,157,158,160,149,151,427,142,143,428,430,318] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [49,50,593,598,577,578,818,575,44,46,43,817,820] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [660,727,728,731,734,736,741,698,733,663,697,628,641,642,643,644,645,653,738] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        