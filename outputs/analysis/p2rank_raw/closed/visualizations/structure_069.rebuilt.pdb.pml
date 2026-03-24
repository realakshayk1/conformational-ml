
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
        
        load "data/structure_069.rebuilt.pdb", protein
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
 
        load "data/structure_069.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [28,875,878,892,893,888,908,889,890,921,923,919,948,962,911,912,913,928,963,448,883,881,886,902,903,905,918,531,25,26,30,535,527,528,956,960,18,428,433,513,953,43,852,853,437,438,440,35,872,868,870,865,867,869,871,423,534,33,538,973,966,969,971,435,465,478,479,480,483,463,446,502,509,510] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.416,0.278,0.702]
select surf_pocket2, protein and id [150,151,153,143,168,183,316,317,318,300,443,441,320,337,338,358,357,429,430,354,355,332,333,223,331,213,313,315,328,335,348,350,353,154,156,157,158,169,170,171,172,288,285,291,175,218,224,226,227,230,243,293,296,263,228,193,426,436,439,427] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.902,0.361,0.878]
select surf_pocket3, protein and id [63,1042,1043,77,78,93,1044,1045,1046,1056,1057,1058,1060,1061,1063,1048,536,540,542,978,976,975,964,968,970,988,62,1027,1028,1008,1054,1055,13,81,95,97,98,3,96,408,138,66,67,75,23,532,533,12,526,530,417,418,412,416] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.702,0.278,0.380]
select surf_pocket4, protein and id [338,358,357,501,502,503,505,498,429,432,430,322,478,477,354,355,403,142,143,339,340,341,325,15,18,411,425,427,428,431,433,513,413,145,140,409,410,135,406,402,8,401] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.620,0.361]
select surf_pocket5, protein and id [51,52,53,38,46,49,50,556,560,59,60,61,543,541,537,546,547,549,551,63,553,418,65,44,40,35,23,24,25,26,30,29,64] 
set surface_color,  pcol5, surf_pocket5 
   
        
        deselect
        
        orient
        