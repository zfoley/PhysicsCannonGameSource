package 
{
	import events.GameEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	import game.GameLogic;
	import game.HUD;
	import game.Input;
	import game.PhysicsGame;
	import game.SoundManager;
	import screens.GameCompleteScreen;
	import screens.HelpScreen;
	import screens.IntroAnimation;
	import screens.PauseScreen;
	import screens.StartScreen;
	
		
	/**
	 * Main class handles Application Logic.
	 * It does not handle game logic. that is handled by the game class.
	 * It manages the adding and removal of screens, and communicates with the screens and game.
	 * It instantiates the game, and dispatches events to start, end, restart and pause the game.
	 * It instantiates the sound manager, and dispatches events to start, end, restart and pause sounds.
	 * It exposes graphics and sounds to the game and UI classes.
	 * it recives and routes UI events to and from the game and sound manager. 
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Main extends Sprite 
	{
		//Screens
		private var introAnimation:Sprite
		private var startScreen:Sprite;
		private var helpScreen:Sprite;
		private var gameCompleteScreen:GameCompleteScreen;
		private var pauseScreen:Sprite;
		
		private var gameSprite:GameLogic
		
		public var _mochiads_game_id:String = "YOUR MOCHI ID HERE";
		public static var APP_DOM:ApplicationDomain;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			APP_DOM = ApplicationDomain.currentDomain;
			createScreens();			
			playIntroAnimation();	
			var input:Input = new Input(this);
		}
		
		private function createScreens():void
		{
			introAnimation = new IntroAnimation();
			introAnimation.addEventListener("introComplete", onIntroComplete)
			
			startScreen = new StartScreen()
			
			helpScreen = new HelpScreen();
			helpScreen.visible = false;
			
			gameCompleteScreen = new GameCompleteScreen();
			gameCompleteScreen.visible = false;
			
			
			pauseScreen =  new PauseScreen();
			pauseScreen.visible = false;
			
			gameSprite = new GameLogic();
					
			addChild(gameSprite);
			
			addChild(startScreen);
			addChild(introAnimation);
			addChild(gameCompleteScreen);
			addChild(pauseScreen);
			addChild(helpScreen);

			
			this.addEventListener(GameEvent.GAME_COMPLETE, showGameCompleteScreen)
			this.addEventListener(GameEvent.CLOSE_SCREEN, closeTargetScreen)
			this.addEventListener(GameEvent.START_GAME, startNewGame);
			this.addEventListener(GameEvent.SHOW_HELP_SCREEN, showHelpScreen);
			this.addEventListener(GameEvent.PAUSE_GAME, pauseGame);
			this.addEventListener(GameEvent.RESUME_GAME, resumeGame);
			
		}
		
		private function showGameCompleteScreen(e:GameEvent):void 
		{
			trace("showGameCompleteScreen", "MAIN");
			gameCompleteScreen.visible = true;
			gameCompleteScreen.setScore(gameSprite.score);
		}
		
		private function resumeGame(e:GameEvent):void 
		{
			trace("Main.resumeGame", "MAIN");
			pauseScreen.visible = false;
			gameSprite.resumeGame();
		}
		
		private function pauseGame(e:GameEvent):void 
		{
			trace("Main.PauseGame", "MAIN");
			pauseScreen.visible = true;
			gameSprite.pauseGame();
			
		}
				
		private function closeTargetScreen(e:GameEvent):void 
		{
			e.target.visible = false;
		}
		
		private function hideHelpScreen(e:GameEvent):void 
		{
			helpScreen.visible = false;
		}
		
		private function showHelpScreen(e:GameEvent):void 
		{
			trace("SHOW HELP SCREEN", "MAIN");
			helpScreen.visible = true;
		}
		
		private function startNewGame(e:GameEvent):void 
		{
			gameSprite.startNewGame();
		}
		
		private function onIntroComplete(e:Event):void 
		{
			introAnimation.visible = false;
			
		}
				
		private function playIntroAnimation():void
		{
			//TODO May be encessary to tell introAnimation to play if you want it to play twice.
			introAnimation.visible = true;
		}
		
	}
	
}