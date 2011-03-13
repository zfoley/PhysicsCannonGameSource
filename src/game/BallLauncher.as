package game 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class BallLauncher extends Sprite
	{
		private var _playerArt:Cannon;
		private var meter:StrengthMeter;
		private var _vector:b2Vec2;
		
		public function BallLauncher() 
		{
			meter = new StrengthMeter();
		}
		public function get art():Cannon{
			return _playerArt;
		}
		public function set art(playerart:Cannon):void {
			_playerArt = playerart;
			if (meter != null) {
				meter.removeEventListener(StrengthMeter.FIRED, onFired);
			}
			meter.art = _playerArt.getChildByName("meter") as StrengthMeterArt;
			meter.addEventListener(StrengthMeter.FIRED, onFired);
		}
		
		public function get vector():b2Vec2 { return _vector; }
		
		private function onFired(e:Event):void 
		{
			_vector = meter.vector;
			dispatchEvent(e);
		}
		
	}

}