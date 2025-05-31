module labour::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;
import ParseTree;

import labour::AST;
import labour::Syntax;
import util::Maybe;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

BoulderingWall loadBoulderingWall((start[BoulderingWall])`bouldering_wall <String name> { volumes [<{Volume ","}* volumes>], routes [<{Route ","}* routes>] }`)
 = \boulderingwall("<name>"[1..-1], [loadVolume(volume) | volume <- volumes], [loadRoute(route) | route <- routes]);

Volume loadVolume((Volume)`polygon {<{PolygonKeyValue ","}* keyValues>}`){
    Maybe[Coordinate2D] poly_pos = nothing();
    list[Face] poly_faces = [];

    for (val <- keyValues) {
        switch (val){
            case(PolygonKeyValue)`faces [<{Face ","}* faces>]`:
                poly_faces = [loadFace(face) | face <- faces];
            case(PolygonKeyValue)`<Position pos>`:
                poly_pos = just(loadPosition(pos));
            default:
                throw labourError("Problem in PolygonKeyValue");
        }
    }

    if (poly_pos == nothing())
        throw labourError("Missing value in polygon");

    return polygon(poly_pos.val, poly_faces);
}

Face loadFace((Face)`face {<{FaceKeyValue ","}* keyValues>}`){
    list[Coordinate3D] face_vertices = [];
    list[Hold] face_holds = [];

    for (val <- keyValues) {
        switch (val){
            case(FaceKeyValue)`holds [<{Hold ","}+ holds>]`:
                face_holds = [loadHold(hold) | hold <- holds];
            case(FaceKeyValue)`vertices [<{Coordinate ","}* coords> ]`:
                face_vertices = [loadCoordinate3D(coord) | coord <- coords];
            default:
                throw labourError("Problem in FaceKeyValue");
        }
    }

    return face(face_vertices, face_holds);
}

Hold loadHold((Hold)`hold <HoldIdentifier holdId> {<{HoldKeyValue ","}* keyValues>}`){
    Maybe[str] hold_shape = nothing();
    Maybe[Coordinate2D] hold_pos = nothing();
    Maybe[int] hold_rotation = nothing();
    list[str] hold_color_list = [];
    Maybe[int] hold_start_hold = nothing();
    bool hold_end_hold = false;

    for (val <- keyValues) {
        switch (val){
            case(HoldKeyValue)`shape: <String shape>`:
                hold_shape = just("<shape>"[1..-1]);
            case(HoldKeyValue)`rotation: <Natural rotation>`:
                hold_rotation = just(toInt("<rotation>"));
            case(HoldKeyValue)`start_hold: <Natural start_hold>`:
                hold_start_hold = just(toInt("<start_hold>"));
            case(HoldKeyValue)`end_hold`:
                hold_end_hold = true;
            case(HoldKeyValue)`<Position pos>`:
                hold_pos = just(loadPosition(pos));
            case(HoldKeyValue)`colours [ <{Color ","}* colors> ]`:
                hold_color_list = ["<color>" | color <- colors];
            default:
                throw labourError("Problem in HoldKeyValue");
        }
    }

    if(hold_shape == nothing() || hold_pos == nothing() || size(hold_color_list) == 0)
        throw labourError("Missing value in hold");

    return hold("<holdId>"[1..-1], hold_shape.val, hold_pos.val, hold_rotation, hold_color_list, hold_start_hold, hold_end_hold);
}

Volume loadVolume((Volume)`circle {<{CircleKeyValue ","}* keyValues>}`){
    Maybe[int] circle_depth = nothing();
    Maybe[int] circle_radius = nothing();
    Maybe[Coordinate2D] circle_pos = nothing();
    list[Hold] circle_holds = [];

    for (val <- keyValues) {
        switch (val) {
            case(CircleKeyValue)`holds [<{Hold ","}+ holds>]`:
                rect_holds = [loadHold(hold) | hold <- holds];
            case (CircleKeyValue)`depth: <Integer depth>`: 
                circle_depth = just(toInt("<depth>"));
            case (CircleKeyValue)`radius: <Natural radius>`:
                circle_radius = just(toInt("<radius>"));
            case (CircleKeyValue)`<Position pos>`: 
                circle_pos = just(loadPosition(pos));
            default:
                throw labourError("Problem in CircleKeyValue");
        }
    }

    if (circle_depth == nothing() || circle_radius == nothing() || circle_pos == nothing())
        throw labourError("Missing value in circle");

    return circle(circle_depth.val, circle_pos.val, circle_radius.val, circle_holds);
}

Volume loadVolume((Volume)`rectangle {<{RectangleKeyValue ","}* keyValues>}`){
    Maybe[Coordinate2D] rect_pos = nothing();
    Maybe[int] rect_depth = nothing();
    Maybe[int] rect_width = nothing();
    Maybe[int] rect_height = nothing();
    list[Hold] rect_holds = [];
    

    for (val <- keyValues) {
        switch (val) {
            case(RectangleKeyValue)`holds [<{Hold ","}+ holds>]`:
                rect_holds = [loadHold(hold) | hold <- holds];
            case (RectangleKeyValue)`depth: <Integer depth>`: 
                rect_depth = just(toInt("<depth>"));
            case (RectangleKeyValue)`width: <Natural width>`:
                rect_width = just(toInt("<width>"));
            case (RectangleKeyValue)`height: <Natural height>`:
                rect_height = just(toInt("<height>"));
            case (RectangleKeyValue)`<Position pos>`: 
                rect_pos = just(loadPosition(pos));
            default:
                throw labourError("Problem in RectangleKeyValue");
        }
    }

    if (rect_pos == nothing() || rect_depth == nothing() || rect_width == nothing() || rect_height == nothing())
        throw labourError("Missing value in rectangle");

    return rectangle(rect_depth.val, rect_pos.val, rect_width.val, rect_height.val, rect_holds);
}

Route loadRoute((Route)`bouldering_route <String name> {<{RouteKeyValue ","}* keyValues>}`) {
    Maybe[str] route_grade = nothing();
    Maybe[Coordinate2D] route_gridBasePoint = nothing();

    list[str] route_holdIDList = [];

    for (val <- keyValues) {
        switch (val) {
            case (RouteKeyValue)`grade: <String s>`: {
                route_grade = just("<s>"[1..-1]);
            }
            case (RouteKeyValue)`<GridBasePoint gridBasePoint>`: {
                switch (gridBasePoint){
                    case (GridBasePoint)`grid_base_point <Coordinate c>`:
                        route_gridBasePoint = just(loadCoordinate2D(c));
                    default:
                        throw labourError("Problem in GridBasePoint");
                }
            }
            case (RouteKeyValue)`<HoldIDList holdIDList>`: {
                switch (holdIDList){
                    case (HoldIDList)`holds [ <{HoldIdentifier ","}* holdIDs> ]`: {
                        for (holdID <- holdIDs) {
                            route_holdIDList = push("<holdID>"[1..-1], route_holdIDList);
                        }
                    }
                    default:
                        throw labourError("Problem in HoldIDList");
                }
            }
            default: 
                throw labourError("Problem in RouteKeyValue");
        }
    }

    if (route_grade == nothing() || route_gridBasePoint == nothing())
        throw labourError("Missing value in route");

    return route("<name>"[1..-1], route_grade.val, route_gridBasePoint.val, route_holdIDList);
}

Coordinate2D loadPosition((Position) `pos <Coordinate c>`) {
    return loadCoordinate2D(c);
}

Coordinate3D loadCoordinate3D((Coordinate) `{ <{CoordKeyValue ","}* keyValues> }`) {
    //println(keyValues);
    Maybe[int] x = nothing();
    Maybe[int] y = nothing();
    Maybe[int] z = nothing();

    for (CoordKeyValue kv <- keyValues) {
        switch(kv) {
            case (CoordKeyValue) `x:<Natural n>`: {
                if (x != nothing()) {
                    throw labourError("Coordinate contains \"x\" more than once");
                }
                x = just(toInt("<n>"));
            }
            case (CoordKeyValue) `y:<Natural n>`: {
                if (y != nothing()) {
                    throw labourError("Coordinate contains \"y\" more than once");
                }
                y = just(toInt("<n>"));
            }
            case (CoordKeyValue) `z:<Natural n>`: {
                if (z != nothing()) {
                    throw labourError("Coordinate contains \"z\" more than once");
                }
                z = just(toInt("<n>"));
            }
        }
    }

    if (x == nothing() || y == nothing() || z == nothing()) {
        throw labourError("Coordinate should contain x, y and z");
    }

    return coordinate3d(x.val, y.val, z.val);
}

Coordinate2D loadCoordinate2D((Coordinate) `{ <{CoordKeyValue ","}* keyValues> }`) {
    Maybe[int] x = nothing();
    Maybe[int] y = nothing();

    for (CoordKeyValue kv <- keyValues) {
        switch(kv) {
            case (CoordKeyValue) `x:<Natural n>`: {
                if (x != nothing()) {
                    throw labourError("Coordinate contains \"x\" more than once");
                }
                x = just(toInt("<n>"));
            }
            case (CoordKeyValue) `y:<Natural n>`: {
                if (y != nothing()) {
                    throw labourError("Coordinate contains \"y\" more than once");
                }
                y = just(toInt("<n>"));
            }
        }
    }

    if (x == nothing() || y == nothing()) {
        throw labourError("Coordinate should contain both x and y");
    }

    return coordinate2d(x.val, y.val);
}

data LabourError = labourError(str description);