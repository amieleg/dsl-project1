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
    bouldering_wall: "bouldering_wall" Id name "{" "volumes" "[" {Volume ","}* "]" "," "routes" "[" {Route ","}* "]" "}" 
;

syntax Volume =
    volume: "volume"
;

syntax Route =
    route: "bouldering_route"
;