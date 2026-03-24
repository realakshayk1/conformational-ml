
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
        
        load "data/structure_017.rebuilt.pdb", protein
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
 
        load "data/structure_017.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [27,28,888,962,953,949,951,921,905,907,908,911,918,919,885,889,890,891,538,893,970,892,528,531,420,535,430,433,434,435,437,923,948,507,510,511,513,508,950,18,422,31,32,33,873,872,505,478,503,504,483,462,466] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.322,0.702]
select surf_pocket2, protein and id [477,478,502,143,355,357,358,338,340,322,325,339,342,345,155,168,320,318,458,141,403,18,413,428,8,510,512,513,427,430,433,135,15,425,151,152,154,426,157,158] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.467,0.361,0.902]
select surf_pocket3, protein and id [63,533,1043,78,1061,1063,1065,1044,1045,1046,1066,82,408,411,23,415,14,11,12,13,517,519,521,3,100,79,80,93,95,97,98,1068,412,405,2,4,5,398,61,62,64,65,66,67,68,83,148,145,418,416,45] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.490,0.278,0.702]
select surf_pocket4, protein and id [211,213,193,207,216,226,229,247,230,250,218,181,186,175,172,290,191,173,263,288,165,183,188,167,168,221,223,227,228,331,332,333,334,335,348,352,353,143,338] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.792,0.361,0.902]
select surf_pocket5, protein and id [46,47,48,49,50,603,43,818,793,817,802,560,577,578,579,580,581,588,590,596,597,833,819,821,837,838,563,803,831,832,834,836,853,35,37,52,553,41] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.659]
select surf_pocket6, protein and id [171,172,290,292,293,294,295,296,285,288,289,291,173,243,230,157,158,317,318,443,455,458,303,316,312,155,168,228] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.682]
select surf_pocket7, protein and id [59,60,61,66,56,418,29,31,34,36,38,40,30,421,63,23,24,25,26,45] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.278,0.408]
select surf_pocket8, protein and id [30,421,423,424,438,439,441,426,854,856,873,857,869,871,442,872,150,425,152,154,427,436,428,458,852,158,850] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.361,0.361]
select surf_pocket9, protein and id [1038,977,978,981,983,998,1022,975,976,987,996,986,991,994] 
set surface_color,  pcol9, surf_pocket9 
set_color pcol10 = [0.702,0.408,0.278]
select surf_pocket10, protein and id [695,696,717,718,714,715,716,669,671,672,673,616,618,721,666,667,698,700,710,719] 
set surface_color,  pcol10, surf_pocket10 
set_color pcol11 = [0.902,0.682,0.361]
select surf_pocket11, protein and id [663,698,763,697,726,727,729,731,728,656,652,653,628] 
set surface_color,  pcol11, surf_pocket11 
set_color pcol12 = [0.702,0.659,0.278]
select surf_pocket12, protein and id [323,324,326,328,456,473,303,313,316,302,307,309,310] 
set surface_color,  pcol12, surf_pocket12 
   
        
        deselect
        
        orient
        