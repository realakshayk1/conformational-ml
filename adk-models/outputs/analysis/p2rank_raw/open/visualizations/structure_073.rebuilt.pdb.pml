
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
        
        load "data/structure_073.rebuilt.pdb", protein
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
 
        load "data/structure_073.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [33,543,545,978,65,76,78,80,82,83,93,95,1043,1042,1045,1063,94,1061,1062,533,968,1058,1023,1022,1038,1040,1041,1024,1025,985,987,988,990,977,58,73,54,61,62,63,976,969,970,21,23,13,407,11,408,128,97,98,525,523,3,118,418,138,85,405,5] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.278,0.278,0.702]
select surf_pocket2, protein and id [8,401,403,405,397,398,399,383,385,505,511,503,504,477,478,151,152,153,412,413,149,150,147,143,428,430,431,433,14,15,18,325,337,338,339,340,356,357,358,359,360,320,333,334,336,353] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.576,0.361,0.902]
select surf_pocket3, protein and id [505,513,515,503,478,481,482,428,430,431,433,435,413,18,20,528,526,524,953,955,28,890,904,906,907,908,910,462,463,465,483,923,926,905,963] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.616,0.278,0.702]
select surf_pocket4, protein and id [291,292,293,296,298,313,314,316,318,317,172,173,242,243,171,315,333,223,239,241,237,238,283,259,260,257,258,175,263,245,261,253,256] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.792]
select surf_pocket5, protein and id [38,39,40,41,43,46,562,565,578,553,555,853,840,563,53,834,835,836,837,838,833,820,48,581,582] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.447]
select surf_pocket6, protein and id [620,622,659,661,663,697,698,701,763,720,762,755,727,728,731,725,660,626,653,655,628] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.361,0.361]
select surf_pocket7, protein and id [401,403,399,400,131,381,382,383,133,142,143,356,357,358,378,338] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.447,0.278]
select surf_pocket8, protein and id [172,173,243,165,167,168,171,183,185,187,188,332,333,335,353,227,228,223,224,226,348] 
set surface_color,  pcol8, surf_pocket8 
set_color pcol9 = [0.902,0.792,0.361]
select surf_pocket9, protein and id [618,763,720,713,716,717,718,669,671,672,673,692,696,698,620,664,665,666,663] 
set surface_color,  pcol9, surf_pocket9 
   
        
        deselect
        
        orient
        