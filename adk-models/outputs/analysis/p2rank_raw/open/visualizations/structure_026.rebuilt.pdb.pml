
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
        
        load "data/structure_026.rebuilt.pdb", protein
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
 
        load "data/structure_026.rebuilt.pdb_points.pdb.gz", points
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
select surf_pocket1, protein and id [77,78,81,82,85,1045,1063,1064,1065,100,93,98,115,118,113,114,116,543,19,20,21,22,23,531,532,533,521,523,525,968,58,60,978,1025,1043,1024,1027,985,1010,1023,539,540,541,407,408,2,3,128,13,10,12,415] 
set surface_color,  pcol1, surf_pocket1 
set_color pcol2 = [0.302,0.278,0.702]
select surf_pocket2, protein and id [151,152,153,149,150,510,416,420,145,412,14,15,413,11,7,142,143,405,401,403,133,135,383,385,140,144,146,427,428,431,432,433,478,503,505,458,457,336,335,337,340,354,355,356,352,353,357,358,168,305,338,477,295,300,318,304,310,321,322,323] 
set surface_color,  pcol2, surf_pocket2 
set_color pcol3 = [0.631,0.361,0.902]
select surf_pocket3, protein and id [291,292,293,296,317,318,316,260,258,261,172,173,243,262,265,298,313,238,314,315,239,241,242,225,240,333,222,289,425,286,287,275,154,155,157,158,159,160,153] 
set surface_color,  pcol3, surf_pocket3 
set_color pcol4 = [0.678,0.278,0.702]
select surf_pocket4, protein and id [953,505,428,433,923,463,16,18,413,511,512,514,516,28,535,526,528,955,890,906,907,908,910,889,891,892,521,524] 
set surface_color,  pcol4, surf_pocket4 
set_color pcol5 = [0.902,0.361,0.682]
select surf_pocket5, protein and id [673,618,720,763,716,717,718,719,713,696,725,697,700,712,733,727,731,655,663,672] 
set surface_color,  pcol5, surf_pocket5 
set_color pcol6 = [0.702,0.278,0.341]
select surf_pocket6, protein and id [48,37,38,560,578,553,555,559,551,853,855,837,838,562] 
set surface_color,  pcol6, surf_pocket6 
set_color pcol7 = [0.902,0.522,0.361]
select surf_pocket7, protein and id [185,186,348,332,333,188,335,353,170,183,184,168] 
set surface_color,  pcol7, surf_pocket7 
set_color pcol8 = [0.702,0.596,0.278]
select surf_pocket8, protein and id [543,23,533,63,60,35,27,31,541,26,539,418] 
set surface_color,  pcol8, surf_pocket8 
   
        
        deselect
        
        orient
        