
--[[

 stream trace callbacks in efficient data structure to central debug collector
 this allows full playback, rewind, of application state
 would also allow searching for patterns in application behaviour
 consider it as a realtime lint style operation for bugs or performance issues

- data structure for trace, trace point
	- source file,line: table lookup 16bit index, 16bit line
	- function name: table lookup 32bit index?
	- local variables, upvalues: table lookup per file, 16bit index (can reuse index from source)
	- global state
- needs to be highly space efficient; even at cost of slow extraction


]]

