module labour::Syntax

/*
 * Define a concrete syntax for LaBouR. The language's specification is available in the PDF (Section 2)
 */

/*
 * Note, the Server expects the language base to be called BoulderingWall.
 * You are free to change this name, but if you do so, make sure to change everywhere else to make sure the
 * plugin works accordingly.
 */

lexical Integer = "-"?[0-9]+;
lexical Natural = [0-9];
lexical Identifier = [a-z_]+;
lexical String = "\""[A-Za-z0-9\-\ ]*"\"";
lexical Color = [a-z];
lexical HoldID = "\""[0-9]"\"";

layout Whitespace = [\ \t\n\r\f]*;

start syntax BoulderingWall
    = "bouldering_wall" String "{" "volumes" "," "routes" RouteList "}";

syntax Position
    = "{" {PositionKeyValue ","}+ "}";

syntax PositionKeyValue
    = "x:" Natural
    | "y:" Natural
    | "z:" Natural
    ;

syntax PositionList = "[" {Position ","}+ "]";
syntax ColorList = "[" {Color ","}+ "]";
syntax HoldIDList = "[" {HoldID ","}* "]";
syntax HoldList = "[" {Hold ","}+ "]";
syntax Hold
    = "hold" HoldID "{" {HoldKeyValue ","}* "}";

syntax HoldKeyValue
    = "pos" Position
    | "shape:" String
    | "rotation:" Natural
    | "colours" ColorList
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
    = "pos" Position
    | "depth:" Integer
    | "radius:" Natural
    ;

syntax Rectangle
    = "rectangle" "{" {RectangleKeyValue ","}* "}";

syntax RectangleKeyValue
    = "pos" Position
    | "depth:" Integer
    | "width:" Natural
    | "height:" Natural
    | "holds" HoldList
    ;

syntax Polygon
    = "polygon" "{" {PolygonKeyValue ","}* "}";

syntax PolygonKeyValue
    = "pos" Position
    | "faces" FaceList;

syntax FaceList = "[" {Face ","}+ "]";
syntax Face
    = "face" "{" {FaceKeyValue ","}* "}";
syntax FaceKeyValue
    = "vertices" PositionList
    | "holds" HoldList
    ; 

syntax RouteList = "[" {Route ","}* "]";
syntax Route = "bouldering_route" String "{" {RouteKeyValue ","}*"}";
syntax RouteKeyValue
    = "grade:" String
    | "grid_base_points" Position
    | "holds" HoldIDList
    ;