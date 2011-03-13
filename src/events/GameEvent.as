package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class GameEvent extends Event
	{
		
		static public const UPDATE:String = "update";
		static public const START_GAME:String = "startGame";
		static public const GAME_OVER:String = "endGame";
		static public const GAME_COMPLETE:String = "gameComplete";
		static public const PAUSE_GAME:String = "pauseGame";
		static public const SHOW_BONUS_CONTENT:String = "showBonusContent";
		static public const RESUME_GAME:String = "resumeGame";
		static public const SHOW_HELP_SCREEN:String = "showHelpScreen";
		static public const CLOSE_SCREEN:String = "closeScreen";
		static public const BILLBOARD_COMPLETE:String = "billboardComplete";
		
		public function GameEvent(type:String, bubbles:Boolean = true, cancellable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}

	}
	
}