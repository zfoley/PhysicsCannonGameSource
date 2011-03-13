package game 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class ScoreBurst extends Sprite
	{
		private var stars:Array;
		private var txt:ScoreText;
		private var timer:Timer;
		
		public function ScoreBurst() 
		{
			txt = new ScoreText();
			stars = [];
			for (var i:int = 0; i < 10; i++) 
			{
				var s:DisplayObject = new Star();
				addChild(s);
				var star:Particle = new Particle();
				star.sprite = s;
				stars.push(star);
			}
			addChild(txt);
			timer = new Timer(30, 250);
			timer.addEventListener(TimerEvent.TIMER, update)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, kill)
		}
		
		private function kill(e:TimerEvent):void 
		{
			stars = [];
			timer = null
			txt = null;
			this.visible = false;
		}
		
		private function update(e:TimerEvent):void 
		{
			for (var i:int = 0; i < stars.length; i++) 
			{
				var s:Particle = stars[i];
				s.vx *= 0.90;
				s.vy += 0.25;
				s.x += s.vx;
				s.y += s.vy;
				
				var art:DisplayObject = s.sprite;
				art.x = s.x;
				art.y = s.y;
				art.rotation += s.rot;
				art.scaleX *= 0.9;
				art.scaleY *= 0.9;
			}
			
		}
		public function explode(xpos:Number, ypos:Number, score:int = 500):void {
			txt.score.text = addCommas(score);
			this.x = xpos;
			this.y = ypos;
			for (var i:int = 0; i < stars.length; i++) 
			{
				stars[i].x = 0;
				stars[i].y = 0;
				var magnitude:Number = Math.random();
				stars[i].vx = (10 - (Math.random() * 20))// * ( magnitude);
				stars[i].vy = (10 - (Math.random() * 20))// * ( magnitude);
				stars[i].ay = 1;
				stars[i].rot = (1.5 - (Math.random() * 3)) / magnitude;
				stars[i].sprite.scaleX = stars[i].sprite.scaleY = magnitude;
				
			}
			timer.start();
			TweenMax.fromTo(txt, 0.75, { scaleX:0.01, scaleY:0.01 } , { scaleX:1, scaleY:1, ease:Back.easeOut } );
			TweenMax.to(txt, 0.5, {autoAlpha:0, ease:Expo.easeOut, delay:0.95});
			
		}
		private function addCommas(number:Number):String {

			var negNum:String = "";
			if(number<0){
				negNum = "-";
				number = Math.abs(number);
			}
			var num:String = String(number);
			var results:Array = num.split(/\./);
			num=results[0];

			if (num.length>3) {
				var mod:Number = num.length%3;
				var output:String = num.substr(0, mod);
				for (var i:Number = mod; i<num.length; i += 3) {
					output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);
				}
				if(results.length>1){
					if(results[1].length == 1){
						return negNum+output+"."+results[1]+"0";
					}else{
						return negNum+output+"."+results[1];
					}
				}else{
				return negNum+output;
				}
			}
			if(results.length>1){
				if(results[1].length == 1){
					return negNum+num+"."+results[1]+"0";
				}else{
					return negNum+num+"."+results[1];
				}
			}else{
				return negNum+num;
			}
		}		

		
	}
	
}
import flash.display.DisplayObject;
class Particle{
	public var x:Number, y:Number, vx:Number, vy:Number, ax:Number, ay:Number, rot:Number;
	public var sprite:DisplayObject
}