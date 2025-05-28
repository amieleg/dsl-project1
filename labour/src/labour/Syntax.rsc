module labour::Syntax

/*
 * Define a concrete syntax for LaBouR. The language's specification is available in the PDF (Section 2)
 */

/*
 * Note, the Server expects the language base to be called BoulderingWall.
 * You are free to change this name, but if you do so, make sure to change everywhere else to make sure the
 * plugin works accordingly.
 */

/*

    TODO: Check if HoldID can be specified in syntax

*/

lexical Integer = "-"?[0-9]+;
lexical Natural = [0-9]*;
lexical Identifier = [a-z_]+;
lexical String = "\""[A-Za-z0-9\-\ ]*"\"";
lexical Color = 'white' | 'yellow' | 'green' | 'blue' | 'red' | 'purple' | 'pink' | 'black' | 'orange';

layout Whitespace = [\ \t\n\r\f]*;

//start syntax BoulderingWall
//    = "bouldering_wall" String "{" "routes" RouteList "}";
start syntax BoulderingWall
    = "bouldering_wall" String "{" Volumes "," RouteList "}";

syntax Position = "pos" Coordinate;

syntax Coordinate = "{" {CoordKeyValue ","}+ "}";
syntax CoordKeyValue
    = "x:" Natural
    | "y:" Natural
    | "z:" Natural
    ;

syntax Vertices = "vertices" "[" {Coordinate ","}+ "]";
syntax ColorList = "colours" "[" {Color ","}+ "]";
syntax HoldIDList = "holds" "[" {String ","}* "]";
syntax HoldList = "[" {Hold ","}+ "]";
syntax Hold
    = "hold" String "{" {HoldKeyValue ","}* "}";

syntax HoldKeyValue
    = "shape:" String
    | Position
    | "rotation:" Natural
    | ColorList
    | "start_hold:" Natural
    | "end_hold"
    ;

syntax Volumes = "volumes" "[" {Volume ","}* "]";
syntax Volume
    = Circle
    | Polygon
    | Rectangle
    ;

syntax Circle
    = "circle" "{" {CircleKeyValue ","}* "}";

syntax CircleKeyValue
    = "depth:" Integer
    | Position
    | "radius:" Natural
    ;

syntax Rectangle
    = "rectangle" "{" {RectangleKeyValue ","}* "}";

syntax RectangleKeyValue
    = "depth:" Integer
    | Position
    | "width:" Natural
    | "height:" Natural
    | "holds" HoldList
    ;

syntax Polygon
    = "polygon" "{" {PolygonKeyValue ","}* "}";

syntax PolygonKeyValue
    = Position
    | FaceList;

syntax FaceList = "faces" "[" {Face ","}+ "]";
syntax Face
    = "face" "{" {FaceKeyValue ","}* "}";
syntax FaceKeyValue
    = Vertices
    | "holds" HoldList
    ; 


syntax RouteList = "routes" "[" Route {"," Route}* "]";
syntax Route = "bouldering_route" String "{" RouteKeyValueList "}";
syntax RouteKeyValueList = RouteKeyValue ("," RouteKeyValue)*;


//syntax Route = "bouldering_route" String "{" {RouteKeyValue ","}*"}";
syntax RouteKeyValue
    = "grade:" String
    | GridBasePoint
    | HoldIDList
    ;

syntax GridBasePoint = "grid_base_point" Coordinate;