package game 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class StrengthMeter extends Sprite
	{
		private static var BLUE:uint = 0x3E8DB6;
		public static var FIRED:String = "CoinLoauncherFired"
		private var _art:StrengthMeterArt;
		private var fullness:Sprite;
		private var marker:Sprite;
		private var canvas:Shape;
		private var _vector:b2Vec2;
		private var lastShot:Shape;
		
		public function StrengthMeter() 
		{
			lastShot = new Shape();
			lastShot.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			lastShot.graphics.beginFill(BLUE, 0.5);
			lastShot.graphics.drawCircle(0, 0, 3);
			lastShot.filters = [new GlowFilter(0xFFFFFF, 1, 4, 4, 2, 1)];
			canvas = new Shape();
			canvas.filters = [new GlowFilter(0xFFFFFF, 1, 4, 4, 2, 1)];
		}
		public function set art(art:StrengthMeterArt):void {
			if (_art != null) {
				removeEventListeners();
			}
			_art = art;
			_art.addChildAt(canvas, 3);
			_art.addChildAt(lastShot, 3);
			fullness = _art.getChildByName("fullness") as Sprite;
			marker = _art.getChildByName("marker") as Sprite;
			marker.x = 0;
			marker.y = 0;
			lastShot.x = 0;
			lastShot.y = 0;
			canvas.graphics.clear();
			addEventListeners();
		}
		
		public function get vector():b2Vec2 { return _vector; }
		
		private function addEventListeners():void
		{
			_art.buttonMode = true;
			_art.mouseChildren = false;
			_art.addEventListener(MouseEvent.CLICK, onMouseClick);
			_art.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			// Set Marker
			//marker.x = e.localX;
			//marker.y = e.localY;
			//canvas.graphics.clear();
			//canvas.graphics.lineStyle(2, BLUE);
			//canvas.graphics.moveTo(0, 0);
			//canvas.graphics.lineTo(e.localX, e.localY);			
			lastShot.x = e.localX;
			lastShot.y = e.localY;
			_vector = new b2Vec2(e.localX, e.localY);
			dispatchEvent(new Event(FIRED, true));
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var p1:Point = new Point();
			var p2:Point = new Point(e.localX, e.localY);
			var distance:Number = Point.distance(p1, p2);
			fullness.width = fullness.height = distance * 2;
			marker.x = e.localX;
			marker.y = e.localY;
			canvas.graphics.clear();
			canvas.graphics.lineStyle(2, BLUE);
			canvas.graphics.moveTo(0, 0);
			canvas.graphics.lineTo(e.localX, e.localY);			
		}
		
		private function removeEventListeners():void
		{
			
		}
	}

}