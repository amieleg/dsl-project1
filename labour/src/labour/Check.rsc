module labour::Check

import labour::AST;
import labour::Parser;
import labour::CST2AST;

import Exception;
import IO;
import List;
import Map;
import Prelude;
import Set;
import String;
import util::Maybe;

bool checkBoulderWallConfiguration(BoulderingWall wall){
  list[Hold] holds = concat([getHolds(vol) | vol <- wall.volumes]);
  tuple[str, Hold] convert(Hold h) { return <h.id, h>; };
  map[str, Hold] holds_map = toMapUnique(mapper(holds, convert));

  return (
    checkVolumeAndRoute(wall) &&
    checkNumberOfHolds(wall) &&
    checkStartingHoldsTotalLimit(wall, holds_map) &&
    checkUniqueEndHold(wall, holds_map) &&
    rotationInBounds(wall) &&
    checkFaces(wall) &&
    sameColourHolds(wall, holds_map)
  );
}

// 1. Every wall must have at least one volume and one route.
bool checkVolumeAndRoute(BoulderingWall wall) {
  return !isEmpty(wall.volumes) && !isEmpty(wall.routes);
}

// 2. Every route must have two or more holds.
bool checkNumberOfHolds(BoulderingWall wall) {
  return all(Route r <- wall.routes, size(r.hold_id_list) >= 2);
}

// 3. Every route must have between zero and two hand start holds.
bool checkStartingHoldsTotalLimit(BoulderingWall wall, map[str, Hold] holds) {
  for (r <- wall.routes) {
    list[Hold] start_holds = [holds[hold_id] | hold_id <- r.hold_id_list, holds[hold_id].start_hold != nothing()];
    
    if (size(start_holds) > 2) {
      return false;
    }
  }

  return true;
}

bool hasUniqueEndHold(list[Hold] holds) {
  return size([h | h <- holds, h.end_hold ]) <= 1;
}

// 6. Every route has at most one hold indicated as end_hold.
bool checkUniqueEndHold(BoulderingWall wall, map[str, Hold] holds){
  return all(Route r <- wall.routes, hasUniqueEndHold([holds[h_id] | h_id <- r.hold_id_list]));
}

// 8. The holds in a bouldering route must all have the same colour, but some holds may be multi-coloured (think of a plexiglas hold with some coloured pieces visible inside), in which case one of these colours has to match the route’s colour. The order of the colours in a multi-coloured hold does not matter.
bool sameColourHolds(BoulderingWall wall, map[str, Hold] holds) {
  bool sameColour(list[str] holdIds) {
    set[str] initial = toSet(holds[holdIds[0]].color_list);
    set[str] common_colours = (initial | it & toSet(holds[id].color_list) | str id <- holdIds);

    return !isEmpty(common_colours);
  }

  return all(Route r <- wall.routes, sameColour(r.hold_id_list));
}

// 10. If a hold has a rotation, its value must be between 0 and 359.
bool rotationInBounds(BoulderingWall wall) {
  list[Hold] holds = concat([getHolds(vol) | vol <- wall.volumes]);

  bool rotationValid(Maybe[int] rot) {
    switch (rot) {
      case nothing():
        return true;
      case just(i):
        return 0 <= i && i <= 359;
      default:
        throw;
    }
  };

  return all(h <- holds, rotationValid(h.rotation));
}

// 15. A polygonal volume must have an array of at least one face that defines the sides of the volume. Each face must be composed of three points.
bool checkFaces(BoulderingWall wall) {
  for (Volume v <- wall.volumes) {
    switch (v) {
      case Volume::polygon(_, faces):
        if (isEmpty(faces)) {
          return false;
        } else {
          for (Face f <- faces) {
            if (size(f.vertices) != 3) {
              return false;
            }
          }
        }
      default:
        continue;
    }
  }

  return true;
}

// Extracts a list of holds from a volume
list[Hold] getHolds(Volume vol) {
  switch (vol) {
    case Volume::circle(_, _, _):
      return [];
    case Volume::rectangle(_, _, _, _, holds):
      return holds;
    case Volume::polygon(_, faces):
      return concat([f.holds | f <- faces]);
    default:
      return [];
  }
}