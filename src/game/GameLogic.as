package game 
{
	
	import com.greensock.TweenMax;
	import events.GameEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * The game Logic Class starts and ends the game
	 * It also handles events that trigger level changes, and pausing
	 * It controls the physicsGame - the Box2D engine.
	 * @author Zach Foley 
	 * www.plasticsturgeon.com
	 */
	public class GameLogic extends Sprite
	{
		private var hud:HUD // Pause and reset Buttons, score display, etc.
		private var physicsGame:PhysicsGame // graphic representation of the game
		private var timeRemaining:int; // In Time-Based Games you use this. 
		private var updateTimer:Timer // The timer that drives the game
		private var timeLimit:int = 25; //In Time-Based Games the game length in seconds.
		private var updateSpeed:int = 25; //Rate of repeat for update function;
		
		private var _score:Number = 0;
		private var _level:int;
		private var _pointsAtStartOfLevel:int = 0;

		public function GameLogic() 
		{
			physicsGame = new PhysicsGame();
			physicsGame.gameParent = this;
			physicsGame.addEventListener(PhysicsGame.LEVEL_COMPLETE, onLevelComplete);
			hud = new HUD();
			updateTimer = new Timer(updateSpeed, 0);
			updateTimer.addEventListener(TimerEvent.TIMER, update);
			hud.addEventListener("ResetLevel", resetLevel);
			startNewGame();
		}
		
		private function onLevelComplete(e:Event):void 
		{
			trace("Game Stopped for Victory!!!");
			updateTimer.stop();
			_level ++;
			//loadNewLevel();
			if (_level > 12) {
				onGameComplete();
			} else {
				TweenMax.delayedCall(0.5, loadNewLevel);
				TweenMax.delayedCall(0.55, updateTimer.start);
			}
		}
		
		private function onGameComplete():void
		{
			trace("You Won the game and beat all the levels!");
			dispatchEvent(new GameEvent(GameEvent.GAME_COMPLETE));
		}
		
		private function countDownComplete(e:TimerEvent):void 
		{
			trace("countDownComplete", "GAME");
			hud.setTime(String(0));
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OVER, true));
			onGameOver()
		}
		
		private function onCountDownTick(e:TimerEvent):void  
		{
			// UNCOMMENT THIS TO ADD A TIME LIMIT TO YOUR GAME
			//timeRemaining =  (timeLimit*1000/updateSpeed) - updateTimer.currentCount;
			//hud.setTime(String(Math.ceil(timeRemaining/(1000/updateSpeed))));
			//if (timeRemaining <= 0) {
				//countDownComplete(e);
			//}
		}
		
		private function update(e:TimerEvent):void 
		{
			// Do Every Frame.
			onCountDownTick(e);
			physicsGame.update(e);
		}
	
		public function startNewGame():void {
			trace("Start new Game", "GAME");
			addChild(physicsGame);
			addChild(hud);
			// reset tot he first level
			_level = 1;
			loadNewLevel()

			//start updates
			updateTimer.reset();
			updateTimer.start();
			// reset game timer
			timeRemaining = timeLimit;
			hud.setTime(String(timeRemaining));
			SoundManager.startMusic();
		}
		
		
		private function resetLevel(e:Event = null):void {
			// When the player gets stuck and decides to replay a level.
			// We reset the score to the score before the level began
			_score = _pointsAtStartOfLevel;
			hud.setScore(_score.toString());
			loadNewLevel();
		}
		
		private function loadNewLevel():void
		{
			// Tell the physics game which level to load, and record the current score in case the player resets.
			_pointsAtStartOfLevel = _score
			physicsGame.loadLevel(_level);
			
		}

		public function pauseGame(e:Event = null):void {
			// Stop the game loop without ending the game.
			trace("pauseGame e:" + e, "GAME");
			updateTimer.stop();
			SoundManager.pauseMusic();
		}
		
		public function resumeGame(e:Event = null):void {
			// Resume the main game loop.
			trace("resumeGame e:"+e, "GAME");
			updateTimer.start();
			SoundManager.resumeMusic();
		}

		private function onGameOver():void
		{
			// Called when the game is over, the player loses, or the player wins.
			updateTimer.stop();
			SoundManager.stopMusic();
		}
		
		// Variable Accesors (getters/setters) for the score.
		public function get score():Number { return _score; }
		
		public function set score(value:Number):void 
		{
			_score = value;
			hud.setScore(_score.toString());
		}
	}
	
}