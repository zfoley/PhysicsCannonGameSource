package screens 
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
	 * @author Zachary Foley
	 */
	public class GameCompleteScreen extends Sprite
	{
		private var highScoresButton:SimpleButton;
		private var playButton:SimpleButton;
		private var view:GameCompleteScreenArt;
		private var playerscore:int;
		private var readout:TextField;
		private var bonusButton:Sprite;
		
		
		public function GameCompleteScreen() 
		{
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
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
			view = new GameCompleteScreenArt();// as Sprite;
			playButton = view.getChildByName("playAgainButton") as SimpleButton;
			readout = view.getChildByName("readout") as TextField;
			addChild(view);
		}
		public function setScore(value:int):void {
			playerscore = Math.max(0, value);
			readout.text = playerscore.toString();
			// Autop show scoreboard here.
		}
		private function addButtonActions():void
		{
			playButton.addEventListener(MouseEvent.CLICK, handlePlayButtonClick);
			
		}
				
		private function handlePlayButtonClick(e:MouseEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.START_GAME, true));
			this.dispatchEvent(new GameEvent(GameEvent.CLOSE_SCREEN, true));
			
		}
	}
	
}