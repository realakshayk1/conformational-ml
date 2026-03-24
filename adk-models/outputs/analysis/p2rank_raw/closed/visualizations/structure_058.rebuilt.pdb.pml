
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
        
        load "data/structure_058.rebuilt.pdb", protein
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
 
        load "data/structure_058.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [62,73,76,77,78,79,80,30,988,541,543,542,978,98,1043,1045,1040,96,975,968,1058,1059,1061,1063,1068,1060,1007,1008,1009,1010,1023,990,66,67,81,82,83,33,415,22,23,3,4,6,9,408,10,13,518,12,533,535,520,523,118,101,60,68,64,65,5,404,405,400,128] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [513,888,903,902,905,447,463,465,948,952,923,511,507,433,435,437,445,446,908,956,959,960,963,25,530,28,528,886,893,889,891,892,875,880,883,17,18,953,524,525,526,20,467,481,482,483,478,464,505] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [428,431,413,433,432,143,409,411,513,465,15,511,509,510,150,17,18,320,335,338,325,339,341,503,322,458,478,459,460,340,358] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [30,988,538,543,546,547,985,991,993,551,553,555,32,34,33,53,573,590,577,575,585,560,562,578,36,38,55,60] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [318,292,243,245,228,225,227,172,173,175,320,333,329,315,316,313,314,317] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [351,352,353,329,330,223,328,333,348,188,228,216,225,226,227,213,167,170] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [25,874,875,882,883,886,437,438,870,441,445,446,435,888,447,448] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [140,143,409,410,411,406,403,404,405,383,355,358] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        