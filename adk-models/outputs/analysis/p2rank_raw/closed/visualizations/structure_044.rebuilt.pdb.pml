
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
        
        load "data/structure_044.rebuilt.pdb", protein
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
 
        load "data/structure_044.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [1023,1041,1043,1045,1060,977,978,1058,58,55,974,981,975,543,987,990,986,1038,1036,996,997,998,995,983,60,61,62,65,1063,33,22,23,535,541,533,525,78,93,97,98,99,100,80,81,82,83,417,414,415,416,20,13,10,418,138,135,408,410,103] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.329,0.278,0.702]
select surf_pocket2, protein and id [510,502,503,403,358,145,338,428,356,357,446,478,447,483,481,429,430,500,340,433,435,887,888,908,953,906,907,910,923,448,903,16,8,511,7,513,515,18,411,413,405,407,526,527,528,28,928,963,926] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.698,0.361,0.902]
select surf_pocket3, protein and id [153,163,165,168,170,144,145,150,142,338,428,143,318,263,333,334,335,336,353,337,355,173,316,317,320,313,243,290,293,425] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.639]
select surf_pocket4, protein and id [436,437,438,439,440,873,874,875,431,433,434,435,887,888,448,903,881,883,886,870,420,422,28,36,31,34,27,35,446,447] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.545]
select surf_pocket5, protein and id [28,891,538,963,913,879,32,31,29,30,536,528,530,970,875,888,908,546,548] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.353,0.278]
select surf_pocket6, protein and id [763,662,664,665,661,698,728,717,718,720,727,608,610,618,668,671,672,620,765] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.729,0.361]
select surf_pocket7, protein and id [636,638,740,743,753,755,625,627,760,631,628,641,643,633,728,727,730] 
set surface_color,  pcol7, surf_pocket7 
   
        
        deselect
        
        orient
        