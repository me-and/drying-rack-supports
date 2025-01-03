width = 5;
thickness = 2;

lower_horizontal_diameter = 15;
lower_vertical_diameter = 11.5;
lower_opening_angle = 90;

bar_lengths = [140, 150, 160];
separation = lower_horizontal_diameter + 2*thickness;

hook_diameter = 3.5;
hook_length = 5;

$fn = 180;

// https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
module sector(radius, angles, fn = $fn) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360])
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

for (i = [0 : len(bar_lengths)-1]) {
    bar_length = bar_lengths[i];

    translate([0, i*separation, 0])
    linear_extrude(width)
    union() {
        difference() {
            difference() {
                offset(r=thickness)
                scale([lower_vertical_diameter, lower_horizontal_diameter, 1])
                circle(0.5);

                scale([lower_vertical_diameter, lower_horizontal_diameter, 1])
                circle(0.5);
            };

            scale([lower_vertical_diameter, lower_horizontal_diameter, 1])
            sector(1, [90 - lower_opening_angle/2,
                       90 + lower_opening_angle/2]);
        };

        translate([lower_vertical_diameter/2, -thickness/2, 0])
        square([bar_length + thickness/2, thickness]);

        translate([bar_length + thickness/2 + lower_vertical_diameter/2,
                   thickness/2 + hook_diameter/2,
                   0])
        rotate([0, 0, 180])
        union() {
            difference() {
                circle(hook_diameter/2 + thickness);
                union() {
                    circle(hook_diameter/2);

                    translate([0, -(hook_diameter + thickness), 0])
                    square(hook_diameter*2 + thickness*2);
                };
            };

            translate([hook_length, -(hook_diameter + thickness)/2, 0])
            circle(thickness/2);

            translate([0, -(hook_diameter/2 + thickness), 0])
            square([hook_length, thickness]);
        };
    };
}
