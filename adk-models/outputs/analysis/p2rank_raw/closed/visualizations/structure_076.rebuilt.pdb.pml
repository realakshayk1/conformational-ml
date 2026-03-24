
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
        
        load "data/structure_076.rebuilt.pdb", protein
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
 
        load "data/structure_076.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [413,428,513,502,478,503,404,405,358,403,435,448,903,433,476,481,460,462,463,464,465,510,511,504,506,482,485,483,427,436,429,430,338,143,145,434,437,439,441,446,20,26,27,28,30,33,877,879,880,881,882,886,888,889,893,15,18,515,528,923,907,908,910,906,876,538,475,321,322,323,473,336,325,339,341,342,340] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [81,82,93,408,410,98,103,101,21,23,25,415,535,533,523,1063,10,128,3,12,525,13,417,62,418,65,83,1058,1041,1042,1043,1045,1060,1059,978,970,58,59,60,988,78,1025,542,543,1038,1022,1023,135,137,138] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [332,333,314,315,310,312,170,313,184,186,188,189,190,183,243,291,336,331,337,335,348,353,328,221,222,224,225,226,228,214,203,173,263,155,172,165,167,168,289,290,152,338,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [417,419,62,63,418,65,421,40,23,25,31,29,30,543,420,423] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [321,323,473,468,471,318,303,306,445,453,430,458,460] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        