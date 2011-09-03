# Binary Codec for JSON

The goal of the Binson project is to produce a binary codec for JSON (json.org). 
And hopefully address some of the shortcomings of BSON spec (bsonspec.org).

The priorities for Binson encoding are (in rough order of priority): 

1. Small encoding size (primarily intended for wire transfer)
1. Fast parsing
1. Easy to use & implement
1. JSON spec compatibility 

Binson encodes using a tag, len, value structure. 

Currently Binson is smaller than JSON encoding for all practical encoding cases and significantly faster to encode/decode.

A reference implementation can be found under the org.boris.binson folder in this repository.

## Types

- object: tag, length (number of pairs), length pairs (string, value)
- array, tag, length (number of values), length values 
- values
	- object
	- array 
	- string: tag, length, UTF-8 encoded string
	- number 
		- variable length signed int32
		- int64 (signed, 8 bytes)
		- double (IEEE 754-1985 double precision - 8 bytes)
	- raw byte array: tag, length, bytes
	- false 
	- true
	- null

As per JSON spec, object pairs are explicitly unordered.

## Encoding

The tag is 1 byte in length. It contains the type of the field as well
as the number of bytes used to represent the length of the field 
(for variable length length fields) 

The size of the length field is encoded in the two most significant bits of the 
tag byte.

Bits 5 and 6 must always be zero.

Bits 7 and 8 must be zero for fixed length structures (null, int64, double, false, true) 
	
			  MSN      LSN 	
			+--------------------------------------------------+
	null	| 0 0 0 0  0 0 0 0 | N/A               | N/A       |
	true	| 0 0 0 0  0 0 0 1 | N/A               | N/A       |
	false	| 0 0 0 0  0 0 1 0 | N/A               | N/A       |
	int64	| 0 0 0 0  0 0 1 1 | value (8 bytes)   | N/A       |
	double	| 0 0 0 0  0 1 0 0 | value (8 bytes)   | N/A       |
	object	| x x 0 0  1 0 0 0 | len (num pairs)   | len pairs |
	array	| x x 0 0  1 0 0 1 | len (num elems)   | len elems |
	string	| x x 0 0  1 0 1 0 | len (num bytes)   | len bytes |
	int32	| x x 0 0  1 0 1 1 | value (len bytes) | N/A       |
	raw		| x x 0 0  1 1 0 0 | len (num bytes)   | len bytes |
			+--------------------------------------------------+
	
For variable length fields bits 7 and 8 encode 4 possible length values:

    0 0 = 1 byte
    0 1 = 2 bytes
    1 0 = 3 bytes
    1 1 = 4 bytes
    
In hex the high nibble should be is 0x0, 0x4, 0x8, 0xc

For compatibility with existing languages (see priorities 2 & 3) the corresponding length field is a signed 32 bit integer.

Where applicable, endianness is little. This is includes variable length structures. 

## Examples

    { "hello" : "world" }

    0x08                            : object type with 1 byte length field 
    0x01                            : 1 pair of string/value 
    0x0a                            : string with 1 byte length field 
    0x05                            : 5 bytes for UTF-8 encoding of "hello"
    0x68 0x65 0x6c 0x6c 0x6f        : the UTF-8 encoding of "hello"
    0x0a                            : string with 1 byte length field
    0x05                            : 5 bytes for UTF-8 encoding of "world"
    0x77 0x6f 0x72 0x6c 0x64        : the UTF-8 encoding of "world"
     

## Interoperability with JSON

Binson aims to be compatible with JSON where possible/practical. This achieved except for the inclusion 
of a RAW byte array type, which is a natural inclusion on a binary spec.


