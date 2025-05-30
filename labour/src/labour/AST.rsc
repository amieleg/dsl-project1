module labour::AST

/*
 * Define the Abstract Syntax for LaBouR
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data BoulderingWall
 = \boulderingwall(str name, list[Volume] volumes, list[Route] routes)
 ;

data Volume = circle() | polygon() | rectangle();

data Circle = \circle(int depth,  Coordinate pos, int radius );

data Polygon = \polygon(Coordinate pos, list[Face] face_list);

data Face = \face(list[Coordinate] vertices, list[Hold]);

data Rectangle = \rectangle(int depth, Coordinate pos, int width, int height, list[Hold] holds);

data Hold = \hold(str shape, Coordinate pos, int rotation, list[str] color_list, int start_hold, bool end_hold);

data Route = \route(str name, str grade, Coordinate gris_base_point, list[str] hold_id_list);

data Coordinate = \coordinate(list[CoordKeyValue] vals);

data CoordKeyValue = \coordKeyValue(str dimension, int val);




