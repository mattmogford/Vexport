// =============================================
//
//	Vexporter
//	Copyright 2013 Matt Mogford. All Rights Reserved.
//
// =============================================

package vexport.core
{
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.describeType;
	
	/** 
	 * <b>Vexport</b><br /><br />
	 * The Vexporter class represents the core of the Vexporter framework.<br />
	 * Use the static methods of this class.
	 */
	public class Vexport extends Sprite
	{
		private var _loader:Loader;
		
		public function Vexport(s:Singleton)
		{
			if (!s) throw new Error( "Error: Instantiation failed: Use getInstance() instead of new." );
		}	
		
		/**
		 * <b>vectorToXML</b><br /><br />
		 * Takes a DisplayObject made up of vector shapes and returns XML data. 
		 * @param displayObj - A Sprite or MovieClip that contains only the following recursively : Sprite, MovieClip, Group, Shape, Vectors etc.
		 * @return XML
		 */
		public static function vectorToXML( displayObj:* ):XML
		{
			if( !checkIsValid( displayObj ) )
				throw new Error( "[Vexport] - vectorToXML() - Supplied DisplayObject is invalid or contains invalid DisplayObjects. Use Vexport.checkIsValid() to check validity." );
			
			var x:XML = new XML( <IGraphicsData /> );
			
			var v:Vector.<IGraphicsData> = displayObj.graphics.readGraphicsData( true );
			for( var i:int = 0; i < v.length; i++ ) 
			{
				var obj:IGraphicsData = v [ i ];
				var objXML:XML;
				
				/************************************************************************/
				if( obj is GraphicsStroke )
				{
					var stroke:GraphicsStroke = v[ i ] as GraphicsStroke;
					objXML = new XML( <GraphicsStroke /> );
					objXML.@caps = stroke.caps;
					objXML.@joints = stroke.joints;
					objXML.@miterLimit = stroke.miterLimit;
					objXML.@pixelHinting = stroke.pixelHinting;
					objXML.@scaleMode = stroke.scaleMode;
					objXML.@thickness = stroke.thickness;
						
					if( stroke.fill )
					{
						var strokeSolidFill:GraphicsSolidFill = stroke.fill as GraphicsSolidFill;
						objXML.@color = strokeSolidFill.color;
						objXML.@alpha = strokeSolidFill.alpha;
					}
					else
					{
						objXML.@color = null;
						objXML.@alpha = null;
					}
					
					x.appendChild( objXML );
				}
				/************************************************************************/
				if( obj is GraphicsSolidFill )
				{
					var solidFill:GraphicsSolidFill = v[ i ] as GraphicsSolidFill;
					objXML = new XML( <GraphicsSolidFill /> );
					objXML.@color = solidFill.color;
					objXML.@alpha = solidFill.alpha;
					x.appendChild( objXML );
				}
				/************************************************************************/
				else if( obj is GraphicsPath )
				{
					var path:GraphicsPath = v[ i ] as GraphicsPath;
					objXML = new XML( <GraphicsPath /> );
					/******************/
					var pathCommands:XML = new XML( <commands /> );
					for each( var pathCommand:int in path.commands ) 
					{
						var commandXML:XML = new XML( <command /> );
						commandXML.@int = pathCommand;
						pathCommands.appendChild( commandXML );
					}
					objXML.appendChild( pathCommands );
					/******************/
					var pathData:XML = new XML( <data /> );
					for each( var pathDataObj:int in path.data ) 
					{
						var dataObjXML:XML = new XML( <dataObj /> );
						dataObjXML.@Number = pathDataObj;
						pathData.appendChild( dataObjXML );
					}
					objXML.appendChild( pathData );
					/******************/
					objXML.@winding = path.winding;
					x.appendChild( objXML );
				}
				/************************************************************************/
				else if( obj is GraphicsGradientFill )
				{
					var gradientFill:GraphicsGradientFill = v[ i ] as GraphicsGradientFill;
					objXML = new XML( <GraphicsGradientFill /> );
					/******************/
					var gradientFillAlphas:XML = new XML( <alphas /> );
					for each( var gradientFillAlpha:Number in gradientFill.alphas ) 
					{
						var alphaXML:XML = new XML( <alpha /> );
						alphaXML.@Number = gradientFillAlpha;
						gradientFillAlphas.appendChild( alphaXML );
					}
					objXML.appendChild( gradientFillAlphas );
					/******************/
					var gradientFillColors:XML = new XML( <colors /> );
					for each( var gradientFillColor:uint in gradientFill.colors ) 
					{
						var colorXML:XML = new XML( <color /> );
						colorXML.@uint = gradientFillColor;
						gradientFillColors.appendChild( colorXML );
					}
					objXML.appendChild( gradientFillColors );
					/******************/
					var gradientFillRatios:XML = new XML( <ratios /> );
					for each( var gradientFillRatio:int in gradientFill.ratios ) 
					{
						var ratioXML:XML = new XML( <color /> );
						ratioXML.@int = gradientFillRatio;
						gradientFillRatios.appendChild( ratioXML );
					}
					objXML.appendChild( gradientFillRatios );
					/******************/
					var gradientFillMatrix:XML = new XML( <matrix /> );
					gradientFillMatrix.@a = gradientFill.matrix.a;
					gradientFillMatrix.@b = gradientFill.matrix.b;
					gradientFillMatrix.@c = gradientFill.matrix.c;
					gradientFillMatrix.@d = gradientFill.matrix.d;
					gradientFillMatrix.@tx = gradientFill.matrix.tx;
					gradientFillMatrix.@ty = gradientFill.matrix.ty;
					objXML.appendChild( gradientFillMatrix );
					/******************/
					objXML.@focalPointRatio = gradientFill.focalPointRatio;
					objXML.@interpolationMethod = gradientFill.interpolationMethod;
					objXML.@spreadMethod = gradientFill.spreadMethod;
					objXML.@type = gradientFill.type;
					x.appendChild( objXML );
				}
				/************************************************************************/
				else if( obj is GraphicsEndFill )
				{
					var endFill:GraphicsEndFill = v[ i ] as GraphicsEndFill;
					objXML = new XML( <GraphicsEndFill /> );
					x.appendChild( objXML );
				}
				/************************************************************************/
			}
			
			return x;
		}
		
		/**
		 * <b>xmlToVector</b><br /><br />
		 * Takes XML in the Vexporter format and returns a graphics data vector
		 * @param xml - An XML Object in the Vexporter format. See <code>Vexporter.vectorToXML();</code>
		 * @return Vector.IGraphicsData
		 */
		public static function xmlToVector( xml:XML ):Vector.<IGraphicsData>
		{
			var v:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			
			for( var i:int = 0; i < xml.children().length(); i++ ) 
			{
				var obj:XML = XML( xml.children()[ i ] );
				/************************************************************************/
				if( obj.name() == "GraphicsStroke" )
				{
					var strokeFill:GraphicsSolidFill = new GraphicsSolidFill( obj.@color, obj.@alpha );
					if( !strokeFill.color ) strokeFill = null;
					var stroke:GraphicsStroke = new GraphicsStroke( obj.@thickness, obj.@pixelHinting, obj.@scaleMode, obj.@caps, obj.@joints, obj.@miterLimit, strokeFill );
					v.push( stroke );
				}
				/************************************************************************/
				if( obj.name() == "GraphicsSolidFill" )
				{
					var solidFill:GraphicsSolidFill = new GraphicsSolidFill( obj.@color, obj.@alpha );
					v.push( solidFill );
				}
				/************************************************************************/
				else if( obj.name() == "GraphicsPath" )
				{
					var path:GraphicsPath = new GraphicsPath();
					/******************/
					path.commands = new Vector.<int>();
					var pathCommandsXMLList:XMLList = obj.commands.children();
					for each( var pathCommandXML:XML in pathCommandsXMLList )
					path.commands.push( pathCommandXML.@int );
					/******************/
					path.data = new Vector.<Number>();
					var pathDataXMLList:XMLList = obj.data.children();
					for each( var pathDataXML:XML in pathDataXMLList )
					path.data.push( pathDataXML.@Number );
					/******************/
					v.push( path );
				}
				/************************************************************************/
				else if( obj.name() == "GraphicsGradientFill" )
				{
					var gradientFill:GraphicsGradientFill = new GraphicsGradientFill( obj.@type, null, null, null, null, obj.@spreadMethod, obj.@interpolationMethod, obj.@focalPointRatio );
					/******************/
					gradientFill.alphas = new Array();
					var gradientFillAlphasXMLList:XMLList = obj.alphas.children();
					for each( var gradientFillAlphaXML:XML in gradientFillAlphasXMLList )
					gradientFill.alphas.push( gradientFillAlphaXML.@Number );
					/******************/
					gradientFill.colors = new Array();
					var gradientFillColorsXMLList:XMLList = obj.colors.children();
					for each( var gradientFillColorXML:XML in gradientFillColorsXMLList )
					gradientFill.colors.push( gradientFillColorXML.@uint );
					/******************/
					gradientFill.ratios = new Array();
					var gradientFillRatiosXMLList:XMLList = obj.ratios.children();
					for each( var gradientFillRatioXML:XML in gradientFillRatiosXMLList )
					gradientFill.ratios.push( gradientFillRatioXML.@int );
					/******************/
					gradientFill.matrix = new Matrix( obj.matrix.@a, obj.matrix.@b, obj.matrix.@c, obj.matrix.@d, obj.matrix.@tx, obj.matrix.@ty );
					/******************/
					v.push( gradientFill );
				}
				/************************************************************************/
				else if( obj.name() == "GraphicsEndFill" )
				{
					var endFill:GraphicsEndFill = new GraphicsEndFill();
					v.push( endFill );
				}
				/************************************************************************/
			}		
			
			return v;
		}
		
		/**
		 * <b>checkIsValid</b><br /><br />
		 * Checks to see if the supplied display object can be converted to Vexport XML.<br /> 
		 * @param displayObj - A Sprite or MovieClip that contains only the following recursively : Sprite, MovieClip, Group, Shape, Vectors etc.
		 * @return Boolean
		 */
		public static function checkIsValid( displayObject:* ):Boolean
		{
			if( displayObject is Sprite || displayObject.totalFrames == 1 )
			{
				for( var i:int = 0; i < displayObject.numChildren; i++ ) 
				{
					if( displayObject.getChildAt( i ) is MovieClip )
					{
						//trace( "MovieClip" );
						if( checkIsValid( displayObject.getChildAt( i ) ) )
							return true;
						else
							return false;
					}
					else if( displayObject.getChildAt( i ) is Sprite )
					{
						//trace( "Sprite" );
						if( checkIsValid( displayObject.getChildAt( i ) ) )
							return true;
						else
							return false;
					}
					else if( displayObject.getChildAt( i ) is Shape )
					{
						//trace( "Shape" );
						return true;
					}
					else if( displayObject.getChildAt( i ) is TextField )
					{
						//trace( "TextField" );
						return false;
					}
					else
					{
						trace( "****************" + describeType( displayObject.getChildAt( i ) ) );
					}
				}
				return false;
			}
			else
				return false;
		}
	}
}
class Singleton{}