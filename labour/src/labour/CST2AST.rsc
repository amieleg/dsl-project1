module labour::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;

import labour::AST;
import labour::Syntax;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

BoulderingWall loadBoulderingWall((start[BoulderingWall])`bouldering_wall <Id label> { volumes [ <{Volume ","}* volumes> ] ,  routes [ <{Route ","}* routes> ] }`)
 = \boulderingwall("<label>", [loadVolume(volume) | volume <- volumes], [loadRoute(route) | route <- routes]);

Volume loadVolume((Volume)`volume`) = \volume();

Route loadRoute((Route)`bouldering_route`) = \route();

