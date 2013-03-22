# Vexport
=======

## - Vexport is a tool for Actionscript 3 that converts a Vector based DisplayObject to an XML format.

## - It also can take that same XML format and re-create a Vector based DisplayObject.

**Desktop Application - Coming Soon.**
Will be able to load a swf file, you can then select all the valid DisplayObjects to convert to a compressed data file.
Which can then be loaded using the Vexport.swc

**HOWTO**
```
if( Vexport.checkIsValid( displayObj ) )
{
	var xml:XML = Vexport.vectorToXML( displayObj );
					
	...........
						
	var vectorData:Vector.<IGraphicsData> = Vexport.xmlToVector( xml );
						
	var mc2:MovieClip = new MovieClip();
	mc2.graphics.drawGraphicsData( vectorData );
	this.addChild( mc2 );
}
```