package game 
{
	
	import events.GameEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class HUD extends Sprite
	{
		private var view:HUDArt 
		private var muteToggleButton:MovieClip;
		private var pauseButton:MovieClip;
		private var scoreDisplay:TextField
		private var timeDisplay:TextField
		private var livesDisplay:TextField
		private var _muted:Boolean = false;
		

		public function HUD() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			/*mouseChildren = */mouseEnabled = false;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addView();
			addButtonActions();
		}		
		
		private function addView():void
		{
			view = new HUDArt();
			addChild(view);
			muteToggleButton = view.getChildByName("muteToggleButton") as MovieClip;
			muteToggleButton.mouseChildren = false;
			muteToggleButton.buttonMode = true;
			muteToggleButton.gotoAndStop("_up");
			pauseButton = view.getChildByName("pauseButton") as MovieClip;
			pauseButton.mouseChildren = false;
			pauseButton.buttonMode = true;
			pauseButton.gotoAndStop("unpaused");
			scoreDisplay = view.getChildByName("scoreDisplay") as TextField;
			timeDisplay = view.getChildByName("timeDisplay") as TextField;
			livesDisplay = view.getChildByName("livesDisplay") as TextField;
			
		}
		
		private function addButtonActions():void
		{
			muteToggleButton.addEventListener(MouseEvent.CLICK, onMuteToggleClick);
			muteToggleButton.addEventListener(MouseEvent.ROLL_OUT, onMuteRollout);
			pauseButton.addEventListener(MouseEvent.CLICK, onPauseToggleClick);
			view.resetButton.addEventListener(MouseEvent.CLICK, onResetClick);
			
		}
		
		private function onResetClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event("ResetLevel", true));
		}
		
		private function onMuteRollout(e:MouseEvent):void 
		{
			if (_muted == true) {
				e.target.gotoAndStop("_selected");
			} else {
				e.target.gotoAndStop("_up");
			}			

		}
		
		private function onPauseToggleClick(e:MouseEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.PAUSE_GAME, true));
/*			if (_muted == true) {
				e.target.gotoAndStop("unpaused");
				_muted = false;
				this.dispatchEvent(new GameEvent(GameEvent.RESUME_GAME, true));
			} else {
				e.target.gotoAndStop("paused");
				_muted = true;
				this.dispatchEvent(new GameEvent(GameEvent.PAUSE_GAME, true));
				
			}
*/			
		}
		
		private function onMuteToggleClick(e:MouseEvent):void 
		{
			if (_muted == false) {
				e.target.gotoAndStop("_selected");
				_muted = true;
				SoundManager.muteSound();
			} else {
				e.target.gotoAndStop("_up");
				_muted = false;
				SoundManager.unMuteSound();
			}			
		}
		
		public function getScore():String { return scoreDisplay.text; }
		
		public function setScore(value:String):void 
		{
			scoreDisplay.text = value;
			
		}
		
		public function getTime():String { return timeDisplay.text; }
		
		public function setTime(value:String):void 
		{
			//timeDisplay.text = value;
		}

		public function getLives():String { return livesDisplay.text; }
		
		public function setLives(value:String):void 
		{
			livesDisplay.text = value;
		}

			
	}
	
}
