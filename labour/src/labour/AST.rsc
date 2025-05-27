module labour::AST

/*
 * Define the Abstract Syntax for LaBouR
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data BoulderingWall
 = \boulderingwall(str name, list[Volume] volumes)
 ;

data Volume = \volume();




