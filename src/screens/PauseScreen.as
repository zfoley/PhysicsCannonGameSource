package screens 
{
	
	import events.GameEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class PauseScreen extends Sprite
	{
		private var view:Sprite 
		private var resumeButton:SimpleButton;

		public function PauseScreen() 
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
			view = new PauseScreenArt() as Sprite;
			resumeButton = view.getChildByName("resumeButton") as SimpleButton;
			addChild(view);
		}
		
		private function addButtonActions():void
		{
			resumeButton.addEventListener(MouseEvent.CLICK, handleClose);
			
		}
		
		private function handleClose(e:MouseEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.RESUME_GAME, true));
			this.dispatchEvent(new GameEvent(GameEvent.CLOSE_SCREEN, true));
		}
			
	}
	
}
