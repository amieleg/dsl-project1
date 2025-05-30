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
lexical Natural = [0-9] | [1-9][0-9]*;
lexical Identifier = [a-z_]+;
lexical String = "\""[A-Za-z0-9\-\ ]*"\"";
lexical Color = 'white' | 'yellow' | 'green' | 'blue' | 'red' | 'purple' | 'pink' | 'black' | 'orange';

layout Whitespace = [\ \t\n\r\f]*;

start syntax BoulderingWall = "bouldering_wall" String "{" {(Volumes | RouteList) ","}* "}";

syntax Volumes = "volumes" "[" {Volume ","}* "]";
syntax Volume
    = Circle
    | Polygon
    | Rectangle
    ;

syntax RouteList = "routes" "[" {Route ","}* "]";
syntax Route = "bouldering_route" String "{" {RouteKeyValue ","}* "}";
syntax RouteKeyValue
    = "grade:" String
    | GridBasePoint
    | HoldIDList
    ;


syntax Circle = "circle" "{" {CircleKeyValue ","}* "}";
syntax CircleKeyValue
    = Position
    | "depth:" Integer
    | "radius:" Natural
    ;

syntax Rectangle = "rectangle" "{" {RectangleKeyValue ","}* "}";
syntax RectangleKeyValue
    = Position
    | "depth:" Integer
    | "width:" Natural
    | "height:" Natural
    | "holds" HoldList
    ;

syntax Polygon = "polygon" "{" {PolygonKeyValue ","}* "}";
syntax PolygonKeyValue
    = Position
    | FaceList
    ;

syntax Position = "pos" Coordinate;

syntax HoldIDList = "holds" "[" {String ","}* "]";

syntax GridBasePoint = "grid_base_point" Coordinate;

syntax Coordinate = "{" {CoordKeyValue ","}* "}";
syntax CoordKeyValue
    = "x:" Natural
    | "y:" Natural
    | "z:" Natural
    ;

syntax FaceList = "faces" "[" {Face ","}* "]";
syntax Face = "face" "{" {FaceKeyValue ","}* "}";
syntax FaceKeyValue
    = Vertices
    | "holds" HoldList
    ; 

syntax Vertices = "vertices" "[" {Coordinate ","}* "]";
syntax ColorList = "colours" "[" {Color ","}* "]";

syntax HoldList = "[" {Hold ","}+ "]";
syntax Hold = "hold" String "{" {HoldKeyValue ","}* "}";
syntax HoldKeyValue
    = Position
    | "shape:" String
    | "rotation:" Natural
    | ColorList
    | "start_hold:" Natural
    | "end_hold"
    ;