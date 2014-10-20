package vexport.graphics
{
	import flash.geom.Point;

	public class GraphicsPathData
	{
		private var _color:uint;
		private var _thickness:Number;
		private var _points:Vector.<Point>;
		
		public function GraphicsPathData( c:uint, t:Number, p:Vector.<Point> )
		{
			_color = c;
			_thickness = t;
			_points = p;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
		}

		public function get thickness():Number
		{
			return _thickness;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value;
		}

		public function get points():Vector.<Point>
		{
			return _points;
		}

		public function set points(value:Vector.<Point>):void
		{
			_points = value;
		}
	}
}