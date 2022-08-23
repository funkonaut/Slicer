//Slice 3D model by material thickness into x y z planes for 2d construction
//By Chris Correll 22_8_7


module model(){
    
    idx = slice_vect[slice_idx];
    rotate_vect = [ [0,90,0], [90,180,90], [0,0,0] ];
    translate_vect = [ [-size[1],0,0], [-size[0],-size[1],0],[0,0,0] ];
    difference(){

        rotate(rotate_vect[slice_idx]){ 
        //get the model to 0,0,0 first
        translate([-bbox_min[0],-bbox_min[1],-bbox_min[2]])
            translate(translate_vect[slice_idx])
                import(fn, convexity=3); 
        }

        //dowel holes
        dowel_y = size[idx[1]]/2;
        dowel_x = size[idx[0]];
        dowel_z= size[idx[2]];
        translate([1/10*dowel_x, dowel_y, 0])  
           cylinder(h=dowel_z*2, r=dowel_thickness, center=true);
        translate([1/3 * dowel_x,dowel_y,0])  
            cylinder(h=dowel_z*2, r=dowel_thickness, center=true);
        translate([1/2*dowel_x,dowel_y,0])  
            cylinder(h=dowel_z*2, r=dowel_thickness, center=true);
        translate([2/3*dowel_x,dowel_y,0])  
            cylinder(h=dowel_z*2, r=dowel_thickness, center=true);
        translate([9/10*dowel_x,dowel_y,0])  
            cylinder(h=dowel_z*2, r=dowel_thickness, center=true);
    }
}

//USER SETTINGS
dowel_thickness = 1.25; // dowels to aid construction
material_thickness = 3.175; // 1/8"
slice = material_thickness;
fn = "./shelf_hanger_pin_v2.stl";
//fn = "../A_mesh_solid_fix.stl";
slice_idx = 1; // 0 x slice, 1 y slice, 2 z slice
//bbox_min = [-320.829620, 782.151062, 0.544556];
//bbox_max = [-259.819153, 839.827271, 122.641846];
bbox_min = [-3,-3,-8];
bbox_max = [3,3,8];
size = [bbox_max[0]-bbox_min[0], bbox_max[1]-bbox_min[1], bbox_max[2]-bbox_min[2]];


//DO THE SLICING
model();
slice_vect = [ [2,1,0], [2,0,1], [0,1,2] ];

x_max = size[slice_vect[slice_idx][0]];
y_max = size[slice_vect[slice_idx][1]];
z_max = size[slice_vect[slice_idx][2]];
z_min = 0;

n = floor(sqrt((z_max - z_min)/slice)+1); //for laying out sheet

for(z = [-z_max:slice:z_min]) { 
    i = (z + z_max) / slice;
    x = x_max * (i % n);
    y = y_max * floor(i / n);
    
    translate([x,y,0]) {
        projection(cut=true) 
            translate([0,0,z]) model();
    };
};