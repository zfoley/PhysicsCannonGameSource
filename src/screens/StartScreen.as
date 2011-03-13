package screens 
{
	
	import events.GameEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class StartScreen extends Sprite
	{
		private var view:Sprite 
		private var startButton:SimpleButton;
		private  var helpButton:SimpleButton;
		public function StartScreen() 
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
			addKeyListeners();
		}		
		
		private function addView():void
		{
			view = new StartScreenArt() as Sprite;
			trace("view:" + view, "STARTSCREEN");
			startButton = view.getChildByName("startButton") as SimpleButton;
			helpButton = view.getChildByName("helpButton") as SimpleButton;
			trace("startButton:" + startButton, "STARTSCREEN");
			addChild(view);
		}
		
		private function addButtonActions():void
		{
			startButton.addEventListener(MouseEvent.CLICK, handleStart);
			helpButton.addEventListener(MouseEvent.CLICK, handleHelp);
			//startButton.buttonMode = true;
		}
		private function addKeyListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}
		private function reportKeyDown(event:KeyboardEvent):void 
		{ 
			if (event.keyCode == Keyboard.ENTER) {
				trace("ENTER!!!");
				handleStart(null);
			}
			
		} 

		
		private function handleHelp(e:MouseEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.SHOW_HELP_SCREEN));
		}
		
		private function handleStart(e:MouseEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.CLOSE_SCREEN, true));
			this.dispatchEvent(new GameEvent(GameEvent.START_GAME));
		}
		
	}
	
}