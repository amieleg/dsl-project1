module labour::Parser

import ParseTree;
import IO;
import labour::Syntax;

start[BoulderingWall] parseLaBouR(loc filePath) {
    return parse(#start[BoulderingWall], readFile(filePath));
}

start[BoulderingWall] parseStr(str string) {
    return parse(#start[BoulderingWall], string);
}