module labour::Check

import labour::AST;
import labour::Parser;
import labour::CST2AST;

import util::Maybe;

import IO;
import List;
import Set;
import Prelude;
import String;


/*
 * Implement a well-formedness checker for the LaBouR language. For this you must use the AST.
 * - Hint: Map regular CST arguments (e.g., *, +, ?) to lists
 * - Hint: Map lexical nodes to Rascal primitive types (bool, int, str)
 * - Hint: Use switch to do case distinction with concrete patterns
 */

/*
 * Define a function per each verification defined in the PDF (Section 2.2.)
 * Some examples are provided below.
 */

bool checkBoulderWallConfiguration(BoulderingWall wall){
  bool numberOfHolds = checkNumberOfHolds(wall);

  bool startingLabelLimit = checkStartingHoldsTotalLimit(wall);
  bool unique_end_hold = checkUniqueEndHold(wall);

  return (numberOfHolds && startingLabelLimit && unique_end_hold);
}


/**
9. Every hold must have a position (defined by x and y), a shape, and colour. The
rotation property is optional.
11. The colour values used must be valid. For now, we assume valid colours to be white,
yellow, green, blue, red, purple, pink, black, and orange.
12. There are only three types of volumes: circle, rectangle, and polygon.
13. A circular volume must have a radius, a depth and a position.
14. A rectangular volume must have a depth, a position, a width and a height.
15. A polygonal volume must have an array of at least one face that defines the sides of the
volume. Each face must be composed of three points.
*/

// 1. Every wall must have at least one volume and one route.
bool checkVolumeAndRoute(BoulderingWall wall) {
  return !isEmpty(wall.volumes) && !isEmpty(wall.routes);
}

// 2. Every route must have two or more holds.
bool checkNumberOfHolds(BoulderingWall wall) {
  return all([len(holds) >= 2 | route <- wall.routes]);
}

// 3. Every route must have between zero and two hand start holds.
bool checkStartingHoldsTotalLimit(BoulderingWall wall) {
  return isEmpty([size([hold.start_hold != Nothing  | hold <- route.holds]) > 2 | route <- wall.routes]);
}



// 4. Every route must have a grade, a grid_base_point, and an identifier.
bool checkHoldProperties(BoulderingWall wall) {
  // Do in cst2ast
  return false;
}


// 5. The grid_base_point must have an x and a y component.
bool checkGridBasePoint(BoulderingWall wall) {
  // Do in cst2ast?
  return false;
}

// 6. Every route has at most one hold indicated as end_hold.
bool checkUniqueEndHold(BoulderingWall wall){
  return all([hasUniqueEndHold(r.holds) | r <- wall.routes]);
}

bool hasUniqueEndHold(list[Hold] holds) {
  return size([h | h <- holds, h.end_hold ]) <= 1;
}

// 7. Hold IDs are always defined with four digits, for example, ”0025“. The wall and route IDs can take any alphanumeric character.
bool holdIDs(BoulderingWall wall) {
  // true by syntax definition
  return false;
}

// 8. The holds in a bouldering route must all have the same colour, but some holds may be multi-coloured (think of a plexiglas hold with some coloured pieces visible inside), in which case one of these colours has to match the route’s colour. The order of the colours in a multi-coloured hold does not matter.

bool sameColourHolds(BoulderingWall wall) {
  list[Hold] holds = concat([getHolds(vol) | vol <- wall.volumes]);

  return false;
}

// 10. If a hold has a rotation, its value must be between 0 and 359.
bool rotationInBounds(BoulderingWall wall) {
  list[Hold] holds = concat([getHolds(vol) | vol <- wall.volumes]);

  return all([h.rotation <= 359 && h.rotation >= 0 | h <- holds, h.rotation != Nothing]);
}

list[Hold] getHolds(Volume vol) {
  switch (vol) {
    case Circle(_, _, _):
      return [];
    case Rectangle(_, _, _, _, holds):
      return holds;
    case Polygon(_, faces):
      return concat([f.holds | f <- faces]);
  }
}