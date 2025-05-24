module labour::AST

/*
 * Define the Abstract Syntax for LaBouR
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data BoulderingWall(loc src=|unknown:///|)
  = \bouldering_wall(str name, list[Volume], list[Route])  // Add definition
  ;

data Volume(loc src=|unknown:///|)
  = \volume()
  ;

data Route(loc src=|unknown:///|)
  = \route(str name, str grade, list[str] holds)
  ;

data Point2D(loc src=|unknown:///|)
  = \point2d(int x, int y)
  ;
