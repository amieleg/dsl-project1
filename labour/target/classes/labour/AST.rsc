module labour::AST
import util::Maybe;

data BoulderingWall
 = \boulderingwall(str name, list[Volume] volumes, list[Route] routes)
 ;

data Volume
    = \circle(int depth,  Coordinate2D pos, int radius, list[Hold] holds)
    | \polygon(Coordinate2D pos, list[Face] face_list)
    | \rectangle(int depth, Coordinate2D pos, int width, int height, list[Hold] holds)
    ;

data Face = \face(list[Coordinate3D] vertices, list[Hold] holds);

data Hold = \hold(str id, str shape, Coordinate2D pos, Maybe[int] rotation, list[str] color_list, Maybe[int] start_hold, bool end_hold);

data Route = \route(str name, str grade, Coordinate2D grid_base_point, list[str] hold_id_list);

data Rectangle = \rectangle(str id, int depth, Coordinate2D pos, int width, int height, list[Hold] holds);

data Coordinate2D = \coordinate2d(int x, int y);
data Coordinate3D = \coordinate3d(int x, int y, int z);