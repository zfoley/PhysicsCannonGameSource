package screens 
{
	
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class IntroAnimation extends Sprite
	{
		private var view:IntroAnimationArt 
		public function IntroAnimation() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addView();
		}		
		
		private function addView():void
		{
			view = new IntroAnimationArt()
			addChild(view);
			view.bittyButton.visible = false;
			view.bittyButton.alpha = 0;
			view.introButton.visible = false;
			view.introButton.alpha = 0;
			view.sturgeonButton.alpha = 0;
			
			TweenMax.to(view.sturgeonButton, 0.5, { autoAlpha:1, delay:0});
			TweenMax.to(view.sturgeonButton, 0.5, { autoAlpha:0, delay:3});
			TweenMax.to(view.bittyButton, 0.5, { autoAlpha:1, delay:3.5});
			TweenMax.to(view.bittyButton, 0.5, { autoAlpha:0, delay:6.5});
			TweenMax.to(view.introButton, 0.5, { autoAlpha:1, delay:7, onComplete:onIntroComplete});
			
		}
		
		private function onIntroComplete(e:Event = null):void 
		{
			this.visible = false;
		}	
	}
	
}