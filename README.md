# Binary Codec for JSON

The goal of the Binson project is to produce a binary codec for JSON (json.org). 
And hopefully address some of the shortcomings of BSON spec (bsonspec.org).

The priorities for Binson encoding are (in rough order of priority): 

1. Small encoding size (primarily intended for wire transfer)
1. Fast parsing
1. Easy to use & implement
1. JSON spec compatibility 

Binson encodes using a tag, len, value structure. 

## Types

- object { key,value }*, 0x01, len (number of pairs), key,value,key,value...
  (unordered keys)
- array, 0x01, len, val1,val2
- values
	- object (0x01)
	- array (0x02)
	- string 0x03, len, unicode (utf8 encoded)
	- number 
		- 0x04, variable length signed int32
		- 0x05, int64 (signed, 8 bytes)
		- 0x06, double (IEEE 754-1985 double precision - 8 bytes)
	- raw (0x07) byte array, len (number of bytes)
	- false (0x08)
	- true (0x09)
	- null (0x0a)

## Encoding

The tag is 1 byte in length. It contains the type of the field as well
as the number of bytes used to represent the length of the field 
(for variable length length fields) 

The size of the length field is encode in the two most significant bits of the 
tag byte.
	
			  MSN      LSN 	
			+--------------------------------------------------+
	null	| 0 0 0 0  0 0 0 0 | N/A               | N/A       |
	object	| x x 0 0  0 0 0 1 | len (num pairs)   | len pairs |
	array	| x x 0 0  0 0 1 0 | len (num elems)   | len elems |
	string	| x x 0 0  0 0 1 1 | len (num bytes)   | len bytes |
	int32	| x x 0 0  0 1 0 0 | value (len bytes) | N/A       |
	int64	| 0 0 0 0  0 1 0 1 | value (8 bytes)   | N/A       |
	double	| 0 0 0 0  0 1 1 0 | value (8 bytes)   | N/A       |
	raw		| x x 0 0  0 1 1 1 | len (num bytes)   | len bytes |
	false	| 0 0 0 0  1 0 0 0 | N/A               | N/A       |
	true	| 0 0 0 0  1 0 0 1 | N/A               | N/A       |
			+--------------------------------------------------+
	
Where applicable, endianness is little. This is includes variable length structures. 

Bits 5 and 6 must always be zero.

Bits 7 and 8 must be zero for fixed length structures (null, int64, double, false, true) 

For variable length fields bits 7 and 8 encode 4 possible length values:

    0 0 = 1 byte
    0 1 = 2 bytes
    1 0 = 3 bytes
    1 1 = 4 bytes
    
For compatibility with existing languages (see priorities 2 & 3) the corresponding length field is a signed 32 bit integer.

## Examples

    { "hello" : "world" }

    0x01                            : object type with 1 byte length field 
    0x01                            : 1 pair of string/value 
    0x03                            : string with 1 byte length field 
    0x05                            : 5 bytes for UTF-8 encoding of "hello"
    0x68 0x65 0x6c 0x6c 0x6f        : the UTF-8 encoding of "hello"
    0x43                            : string with 1 byte length field
    0x05                            : 5 bytes for UTF-8 encoding of "world"
    0x77 0x6f 0x72 0x6c 0x64        : the UTF-8 encoding of "world"
     

## Interoperability with JSON

Binson aims to be compatible with JSON where possible/practical. 

