module labour::Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Define a concrete syntax for LaBouR. The language's specification is available in the PDF (Section 2)
 */

/*
 * Note, the Server expects the language base to be called BoulderingWall.
 * You are free to change this name, but if you do so, make sure to change everywhere else to make sure the
 * plugin works accordingly.
 */
lexical UnsignedInt = [0] | ([1-9][0-9]*); 

start syntax BoulderingWall = 
    boulderingwall: "bouldering_wall" "\"" Id name "\"" "{" 
        "volumes"  "[" Volume ("," Volume)* "]" "," "routes " "[" Route ("," Route)* "]"
    "}"  // volumes come first, then routes
 ; 

syntax Volume =
    volume: "volume"
;

syntax Route =
    route: "bouldering_route" Id name "{"
        "grade: " Id grade ","
        "grid_base_point " Point2D ","
        "holds [" Id hold ("," Id holds)* "]"
    "}"
;

syntax Point2D = 
    "{" X "," Y "}"
;

syntax X =
    "x:" UnsignedInt x
;

syntax Y =
    "y:" UnsignedInt y
;

syntax Z = 
    "z:" UnsignedInt z
;


