include <BOSL/constants.scad>
use <BOSL/shapes.scad>

export_box=true;
export_walls=true;
export_lid=true;
board_ghost=false;

$fn=64;
bool_allowance=0.01;
fillet_radius=0;

board_x=170;
board_y=170;
board_z=31.5;
board_thickness=1.6;
wall_thickness=3;
clearance_x=10;
clearance_y=0;
clearance_z=5;
foot_z=10;
foot_coordinates=[
    [6.17,33.02],
    [6.17,165.10],
    [163.65,165.10],
    [163.65,10.16]
];
foot_diameter=6.5;
void_x=board_x+(clearance_x*2);
void_y=board_y+(clearance_y*2);
void_z=export_walls?(board_z+foot_z+clearance_z):
    0;
box_x=void_x+(wall_thickness*2);
box_y=void_y+(wall_thickness*2);
box_z=void_z+wall_thickness;
corner_diameter=8;
insert_z=4;
insert_hole_diameter=4;
insert_hole_y=10;
connector_x=30;
connector_z=17;
connector_offset_x=26;
mount_diameter=3.5;
mount_spacing=30;
vent_x=2;
vent_z=void_z*0.7;
vent_offset_z=(wall_thickness*2);
vent_spacing=2;
board_tweak_x=0;
board_tweak_y=0;
board_tweak_z=0;

// Main box
if(export_box) {
difference(){
    union() {
        difference() {
    // Box
            cuboid([box_x,box_y,box_z],
                center=false, 
                fillet=fillet_radius, 
                edges=EDGES_BOTTOM+EDGES_Z_ALL);
    // Void
            translate([wall_thickness,wall_thickness,wall_thickness]) {
                cuboid([void_x,void_y,
                    (void_z+wall_thickness+bool_allowance)],
                    center=false, 
                    fillet=fillet_radius, 
                    edges=EDGES_BOTTOM+EDGES_Z_ALL);
            }
        }
    // Corner columns for lid fasteners
            for(i=[0:1]) {
                for(j=[0:1]) {
                    translate([
                        max((corner_diameter/2),
                        (((wall_thickness*2)-(corner_diameter/2)+
                            void_x)*i)),
                        max((corner_diameter/2),
                            (((wall_thickness*2)-(corner_diameter/2)+
                            void_y)*j)),wall_thickness]) 
                                zcyl(h=void_z,d=corner_diameter,
                                    center=false);
                }
        }
        // Mounting posts
        for(i=[-1,1]) {
            for(j=[-1,1]) {
                translate([((box_x/2)+(i*mount_spacing*1.5)),
                    ((box_y/2)+(j*mount_spacing*1.5)),0]) {
                        zcyl(h=(wall_thickness+insert_z),
                            d=foot_diameter,
                            center=false);
                    }
            }
        }
        // Board feet
        for(i=foot_coordinates) {
            translate([i[0]+wall_thickness+clearance_x+board_tweak_x,
                        i[1]+wall_thickness+board_tweak_y,
                        wall_thickness]) 
                zcyl(h=foot_z,d=foot_diameter,center=false);
        }
    }
// Mounting insert holes
    for(i=[-1,1]) {
        for(j=[-1,1]) {
            translate([((box_x/2)+(i*mount_spacing*1.5)),
                ((box_y/2)+(j*mount_spacing*1.5)),-bool_allowance]) {
                    zcyl(h=(wall_thickness+insert_z+
                        (bool_allowance*2)),
                        d=insert_hole_diameter,
                        center=false);
                }
        }
    }
    // Hole for corner heat insert nuts
    for(i=[0:1]) {
        for(j=[0:1]) {
            translate([
                max((corner_diameter/2),
                (((wall_thickness*2)-(corner_diameter/2)+void_x)*i)),
                max((corner_diameter/2),
                (((wall_thickness*2)-(corner_diameter/2)+void_y)*j)),
                ((void_z-insert_hole_y)+
                wall_thickness+bool_allowance)]) 
                zcyl(h=insert_hole_y,
                    d=insert_hole_diameter,center=false);
        }
    }
    // Board feet holes for inserts
    for(i=foot_coordinates) {
        translate([i[0]+wall_thickness+clearance_x+board_tweak_x,
                    i[1]+wall_thickness+board_tweak_y,
                    (wall_thickness+foot_z+
                        bool_allowance-insert_hole_y)]) 
            zcyl(h=insert_hole_y,d=insert_hole_diameter,center=false);
    }
    // Ventilation
    ycenter=(box_y-vent_x)/2;
    for(i=[0:1]) {
        for(j=[-9:9]) {
            vent_offset_y=ycenter+(vent_spacing*3*j);
            translate([(-bool_allowance+(wall_thickness+void_x)*i),
                        vent_offset_y,
                        vent_offset_z]) 
                cuboid([(wall_thickness+(bool_allowance*2)),
                        vent_x,vent_z],
                        center=false);
        }
    }
}}

// Lid
if(export_lid) {
    difference() {
#        translate([0,0,box_z]) 
            cuboid([box_x,box_y,(fillet_radius*2)],
                center=false, 
                fillet=fillet_radius, 
                edges=EDGES_TOP+EDGES_Z_ALL);
    // Screw holes
        for(i=[0:1]) {
            for(j=[0:1]) {
                translate([
                    max((corner_diameter/2),
                        (((wall_thickness*2)-(corner_diameter/2)+
                        void_x)*i)),
                    max((corner_diameter/2),
                        (((wall_thickness*2)-(corner_diameter/2)+
                        void_y)*j)),
                    (box_z-bool_allowance)]) 
                    zcyl(h=((fillet_radius*2)+(bool_allowance*2)),
                        d=mount_diameter,center=false);
            }
        }
    }
}

if(board_ghost) {
#    translate([board_tweak_x,board_tweak_y,board_tweak_z]) {
        cuboid([board_x,board_y,board_z],center=false);
    }
}