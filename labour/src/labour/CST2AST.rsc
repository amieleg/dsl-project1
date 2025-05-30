module labour::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;

import labour::AST;
import labour::Syntax;
import util::Maybe;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

BoulderingWall loadBoulderingWall((start[BoulderingWall])`bouldering_wall <String name> { volumes [ <{Volume ","}* volumes> ] ,  routes [ <{Route ","}* routes> ] }`)
 = \boulderingwall("<name>"[1..-1], [loadVolume(volume) | volume <- volumes], [loadRoute(route) | route <- routes]);

//Volume loadVolume((Volume)`<Circle c>`) = loadCircle(c);
//Volume loadVolume((Volume)`<Rectangle r>`) = loadRectangle(r);
//Volume loadVolume((Volume)`<Polygon p>`) = loadPolygon(p);

Volume loadVolume((Volume)`polygon  {<{PolygonKeyValue ","}* keyValues>}`){
    Coordinate poly_pos;
    list[Face] poly_faces;

    for (val <- keyValues) {
        switch (val){
            case(PolygonKeyValue)`faces [<{Face ","}* faces>]`:
                poly_faces = [loadFace(face) | face <- faces];
           case(PolygonKeyValue)`<Position pos>`:
                poly_pos = loadPosition(pos);
            default:
                println("naur");
        }
    }

    return polygon(poly_pos, poly_faces);
}

Face loadFace((Face)`face {<{FaceKeyValue ","}* keyValues>}`){
    list[Coordinate] face_vertices;
    list[Hold] face_holds = [];

    for (val <- keyValues) {
        switch (val){
            case(FaceKeyValue)`holds [<{Hold ","}+ holds>]`:
                face_holds = [loadHold(hold) | hold <- holds];
            case(FaceKeyValue)`vertices [<{Coordinate ","}* coords> ]`:
                face_vertices = [loadCoordinate(coord) | coord <- coords];
            default:
                println("naur");
        }
    }

    return face(face_vertices, face_holds);
}

Hold loadHold((Hold)`hold <HoldIdentifier holdId> {<{HoldKeyValue ","}* keyValues>}`){
    str hold_shape;
    Coordinate hold_pos;
    int hold_rotation = 0;
    list[str] hold_color_list;
    Maybe[int] hold_start_hold = nothing();
    bool hold_end_hold = false;

    for (val <- keyValues) {
        switch (val){
            case(HoldKeyValue)`shape: <String shape>`:
                hold_shape = "<shape>"[1..-1];
            case(HoldKeyValue)`rotation: <Natural rotation>`:
                hold_rotation = toInt("<rotation>");
            case(HoldKeyValue)`start_hold: <Natural start_hold>`:
                hold_start_hold = just(toInt("<start_hold>"));
            case(HoldKeyValue)`end_hold`:
                hold_end_hold = true;
            case(HoldKeyValue)`<Position pos>`:
                hold_pos = loadPosition(pos);
            case(HoldKeyValue)`colours [ <{Color ","}* colors> ]`:
                hold_color_list = ["<color>" | color <- colors];
            default:
                println("naur");
        }
    }

    return hold("<holdId>"[1..-1], hold_shape, hold_pos, hold_rotation, hold_color_list, hold_start_hold, hold_end_hold);
}

Volume loadVolume((Volume)`circle {<{CircleKeyValue ","}* keyValues>}`){
    int circle_depth;
    int circle_radius;
    Coordinate circle_pos;

    for (val <- keyValues) {
        switch (val) {
            case (CircleKeyValue)`depth: <Integer depth>`: 
                circle_depth = toInt("<depth>");
            case (CircleKeyValue)`radius: <Natural radius>`:
                circle_radius = toInt("<radius>");
            case (CircleKeyValue)`<Position pos>`: 
                circle_pos = loadPosition(pos);
            default:
                println("naur");
        }
    }

    return circle(circle_depth, circle_pos, circle_radius);
}

Volume loadVolume((Volume)`rectangle {<{RectangleKeyValue ","}* keyValues>}`){
    Position rect_pos;
    int rect_depth;
    int rect_width;
    int rect_height;
    list[Hold] rect_holds;
    

    for (val <- keyValues) {
        switch (val) {
            case(RectangleKeyValue)`holds [<{Hold ","}+ holds>]`:
                rect_holds = [loadHold(hold) | hold <- holds];
            case (RectangleKeyValue)`depth: <Integer depth>`: 
                rect_depth = toInt("<depth>");
            case (RectangleKeyValue)`width: <Natural width>`:
                rect_width = toInt("<width>");
            case (RectangleKeyValue)`height: <Natural height>`:
                rect_height = toInt("<height>");
            case (RectangleKeyValue)`<Position pos>`: 
                rect_pos = loadPosition(pos);
            default:
                println("naur");
        }
    }

    return rectangle(rect_depth, rect_pos, rect_width, rect_height, rect_holds);
}

Route loadRoute((Route)`bouldering_route <String name> {<{RouteKeyValue ","}* keyValues>}`) {
    str route_grade;
    Coordinate route_gridBasePoint;
    list[str] route_holdIDList = [];
    for (val <- keyValues) {
        switch (val) {
            case (RouteKeyValue)`grade: <String s>`: {
                route_grade = "<s>"[1..-1];
            }
            case (RouteKeyValue)`<GridBasePoint gridBasePoint>`: {
                switch (gridBasePoint){
                    case (GridBasePoint)`grid_base_point <Coordinate c>`:
                        route_gridBasePoint = loadCoordinate(c);
                    default:
                        println("naur");
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
                        println("naur");
                }
            }
            default: 
                println("naur");
        }
    }
    return route("<name>"[1..-1], route_grade, route_gridBasePoint, route_holdIDList);
}

Coordinate loadPosition((Position)`pos <Coordinate coord>`) = loadCoordinate(coord);

Coordinate loadCoordinate((Coordinate)`{ <{CoordKeyValue ","}* keyValues> }`) = \coordinate([loadCoordKeyValue(keyValue) | keyValue <- keyValues]);

CoordKeyValue loadCoordKeyValue((CoordKeyValue)`x: <Natural val>`) = \coordKeyValue("x", toInt("<val>"));
CoordKeyValue loadCoordKeyValue((CoordKeyValue)`y: <Natural val>`) = \coordKeyValue("y", toInt("<val>"));
CoordKeyValue loadCoordKeyValue((CoordKeyValue)`z: <Natural val>`) = \coordKeyValue("z", toInt("<val>"));
