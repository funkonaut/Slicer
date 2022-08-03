// stl render and place
// generate guide holes
// get bounding box using meshlab 
// click bounding box filters> quality measures and computations > compute geometric measures
//Mesh Bounding Box min -320.829620 782.151062 0.544556
//Mesh Bounding Box max -259.819153 839.827271 122.641846
//Mesh Bounding Box Size 61.010468 57.676208 122.097290
//Center of Mass is -290.220123 809.829041 55.147953
//uniform mesh resampling .5 and 55 CLOSE VERTICES OPTION
//remove duplicated vertex remove duplicate faces merge close vertices 10% remove non manifold edges and vertices close holes clustering decimation LAPLACIAN SMOOTH
//export uncheck material and binary encoding options
//fix in inspector in mesh mixer and make solid
// mesh mixer generate solid 1.1 1.4 > fix 
module model(fn,vert,bbox_min,bbox_max,size,dowel_thickness){
    
    idx_x = vert == true ? 0 : 2;
    idx_y = vert == true ? 1 : 0;
    idx_z = vert == true ? 2 : 1;
    
    difference(){
    if(vert != true){
        rotate([90,180,90])
        translate([-1*bbox_min[0],-1*bbox_max[1],-bbox_min[2]])
            import(fn, convexity=3); 
    }
    else{
        translate([-1*bbox_min[0],-1*bbox_max[1],-bbox_min[2]])
            import(fn, convexity=3); 
    }
    
    translate([size[idx_x]/10,-1*size[idx_y]/2,0])  
        cylinder(h=size[idx_z]*2, r=dowel_thickness, center=true);
    translate([size[idx_x]/3,-1*size[idx_y]/2,0])  
        cylinder(h=size[idx_z]*2, r=dowel_thickness, center=true);
    translate([size[idx_x]/2,-1*size[idx_y]/2,0])  
        cylinder(h=size[idx_z]*2, r=dowel_thickness, center=true);
    translate([2*size[idx_x]/3,-1*size[idx_y]/2,0])  
        cylinder(h=size[idx_z]*2, r=dowel_thickness, center=true);
    translate([9*size[idx_x]/10,-1*size[idx_y]/2,0])  
        cylinder(h=size[idx_z]*2, r=dowel_thickness, center=true);
    }
}

//USER SETTINGS
dowel_thickness = 1.25; // dowels to aid construction
material_thickness = 3.175; // 1/8"
slice = material_thickness;
fn ="/A_mesh_solid_fix.stl";
vert = false;
bbox_min = [-320.829620, 782.151062, 0.544556];
bbox_max = [-259.819153, 839.827271, 122.641846];
size = [bbox_max[0]-bbox_min[0], bbox_max[1]-bbox_min[1], bbox_max[2]-bbox_min[2]];
//model(fn,vert,bbox_min,bbox_max,size);


//DO THE SLICING
z_min = 0;
x_max = vert == true ? size[0] : size[2];
y_max = vert == true ? size[1] : size[0];
z_max = vert == true ? size[2] : size[1];


n = floor(sqrt((z_max - z_min)/slice)+1);
for(z = [-z_max:slice:z_min]) { 
    i = (z + z_max) / slice;
    x = x_max * (i % n);
    y = y_max * floor(i / n);
    
    translate([x,y,0]) {
        projection(cut=true) 
            translate([0,0,z]) model(fn,vert,bbox_min,bbox_max,size);;
    };
};