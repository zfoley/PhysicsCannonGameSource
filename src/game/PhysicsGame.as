package game 
{
	import adobe.utils.CustomActions;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	import Box2D.Dynamics.Controllers.b2ControllerEdge;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import com.greensock.plugins.SoundTransformPlugin;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class PhysicsGame extends Sprite
	{
		
		public static var LEVEL_COMPLETE:String = "PhysicGameLevelComplete"; 
		
		private var timestep:Number; // Used by box2D. 
		private var iterations:Number; // How many time box2D solves collisions.
		private var m_world:b2World; // the main box2D world
		public var m_physScale:Number = 30; // Sets the scale of box2d to 1 meter = 30 pixels.
		private var dbgDraw:b2DebugDraw; // A debug drawer.
		private var dbgSprite:Sprite; // Sprite that debug draw draws its render to.
		private var ball:b2Body; // The current ball in play
		private var levelArt:Sprite; // the current level art in use
		private var _levelComplete:Boolean = false; // Flag indicating if the level is over or still in play.
		private var ballLauncher:BallLauncher; // Launches the ball.
		private var ballInPlay:Boolean; // Flag to indicate if the ball has come to a rest yet.
		private var launchTime:Number; // Instant of time when the last ball was launched.
		
		private var buoyancyController:b2BuoyancyController; // Box2D Bouyancy Controller "Water"
		private var objectsThatFloat:Array = []; // lsit of items that are effected by the bouyancy Controller
		private var gravity:b2Vec2; //Direction and amoutn of gravity in the Box2D world
		private var doSleep:Boolean; // Flag - tells box2d if objects are aloud to sleep to improve performance.
		private var ballsArray:Array; //A list of all items that move, and have art that should move with them.
		public var gameParent:GameLogic; // Passed reference to GameLogic Class. Allows the pyhsics game to communicate with the GameLogic.

		
		public function PhysicsGame() 
		{
			// Set up Box2D constants
			timestep = 1.0 / 30.0;
			iterations = 10.0;
			// Define the gravity vector
			gravity = new b2Vec2(0.0, 10.0);
			// Allow bodies to sleep
			doSleep = true;
			dbgSprite = new Sprite();
			addChild(dbgSprite);			
			makeNewWorld()
			
			// Set up our the Ball lauuncher, and the gameTimer
			ballLauncher = new BallLauncher();
			ballLauncher.addEventListener(StrengthMeter.FIRED, launchCoin);			
			var gameTimer:Timer = new Timer(30, 0);
			gameTimer.addEventListener(TimerEvent.TIMER, update)
		}
		
		private function makeNewWorld():void
		{
			// Construct a world object
			m_world = new b2World(gravity, doSleep);
			m_world.SetWarmStarting(true);
			m_world.SetContactListener(new ContactListener(this));
			// set debug draw
			dbgDraw = new b2DebugDraw();
			dbgDraw.SetSprite(dbgSprite);
			dbgDraw.SetDrawScale(30.0);
			dbgDraw.SetFillAlpha(0.5);
			dbgDraw.SetLineThickness(1.0);
			
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			m_world.SetDebugDraw(dbgDraw);

			var bc:b2BuoyancyController = new b2BuoyancyController();
			buoyancyController = bc;
			bc.normal.Set(0,-1);
			bc.offset = -200 / m_physScale;
			bc.density = 2.0;
			bc.linearDrag = 5;
			bc.angularDrag = 2;			
		}
		
		private function launchCoin(e:Event):void 
		{
			if (ballInPlay) { return };
			trace("Kapow!");
			var ballBd:b2BodyDef
			var ballShape:b2CircleShape
			
			var ballArt:Ball = new Ball();
			ballArt.cacheAsBitmap = true;
			levelArt.addChildAt(ballArt, levelArt.numChildren - 1);
			
			ballBd = new b2BodyDef();
			ballBd.position.Set(700 / m_physScale / 2, (150 + 95) / m_physScale);;
			ballBd.linearDamping = 0.5;
			ball = m_world.CreateBody(ballBd);
			ballShape = new b2CircleShape(5/m_physScale);
			var ballFix:b2FixtureDef = new b2FixtureDef();
			ballFix.density = 15.0;
			ballFix.friction = 0.9;	
			ballFix.restitution = 0.5;
			
			ballFix.shape = ballShape
			ball.CreateFixture(ballFix);		
			ball.SetPosition(new b2Vec2(ballLauncher.art.x / m_physScale, ballLauncher.art.y / m_physScale));
			ball.SetType(b2Body.b2_dynamicBody);
			ball.SetUserData( { name:"ball"} );
			ball.SetBullet(true);
			var initalImpulse:b2Vec2 = ballLauncher.vector.Copy();
			initalImpulse.Multiply(0.85);
			ball.ApplyImpulse(initalImpulse, ball.GetPosition());
			ballInPlay = true
			ballLauncher.art.mouseEnabled = false;
			ballLauncher.art.mouseChildren = false;
			launchTime = getTimer() 
			var s:Sound = new FireSound();
			s.play();
			ballsArray.push( { art:ballArt, body:ball } );
		}
		
		/**
		 * This is the main game loop.
		 * Called By the game loop
		 * @param	e
		 */
		public function update(e:TimerEvent):void 
		{
			
			m_world.Step(timestep, iterations, iterations);
			m_world.ClearForces();
			

			
			// Loop throught the bodies and remove target Bodies that have been hit.
			for (var b:b2Body = m_world.GetBodyList(); b != null; b = b.GetNext() ) {				
				if(b.GetUserData() != null){
					if(b.GetUserData().name != undefined){
						if (b.GetUserData().name == "expiredtarget") {
							m_world.DestroyBody(b);
						}
					}
				}
			}
			
			// Render
			m_world.DrawDebugData();
			if (ball != null) {
				if(ball.IsAwake() == false || getTimer() - launchTime > 500){
					ballInPlay = false;
					ballLauncher.art.mouseEnabled = ballLauncher.art.mouseChildren = true;
				}
			}
			// Here we move our art, based on the updates to the box2D world.
			for (var i:int = 0; i < ballsArray.length; i++) 
			{
				ballsArray[i].art.x = ballsArray[i].body.GetPosition().x * m_physScale;
				ballsArray[i].art.y = ballsArray[i].body.GetPosition().y * m_physScale;
			}
			// If the contact listener detected a fast collision, play the "bounce" sound.
			if (ContactListener.CONTACT_MADE) {
				var s:Sound = new BounceSound();
				s.play();
				ContactListener.CONTACT_MADE = false;
			}

		}
		
		/**
		 * Called when a ball body hits a bonus body.
		 * The art is the "star" you see int he game
		 * @param	art
		 */
		public function handleBonusHit(art:Sprite):void {
			art.visible = false;
			var bonusHit:ScoreBurst = new ScoreBurst();
			bonusHit.explode(art.x, art.y, 1750);
			addChild(bonusHit);
			gameParent.score += 1750;
			var s:Sound = new BonusHitSound();
			s.play();
		}
		
		/**
		 * Called to create a new level.
		 * It resets the game to be ready to play a new level.
		 * @param	level
		 */
		public function loadLevel(level:int):void {
			trace("LoadLevel", level);
			
			ball = null;
			makeNewWorld();
			if (levelArt != null) {
				levelArt.visible = false;
			}
			ballsArray = [];
			
			var levels:Array = [new Level1(), new Level2(), new Level3(), new Level4(), new Level5(), new Level6(), new Level7(), new Level8(), new Level9(), new Level10(), new Level11(), new Level12()];
			var levelartclass:Class = ApplicationDomain.currentDomain.getDefinition("Level" + level) as Class;
			levelArt = new levelartclass() as Sprite
			//===========
			// Important
			//===========
			parseLevelArt()
			//===========
			//===========
			
			
			levelComplete = false;
			ballInPlay = false;
			levelComplete = false;			
			ballLauncher.art.mouseEnabled = ballLauncher.art.mouseChildren = true;
			
			// This places our debug drawing behind the level art.
			addChild(dbgSprite);
			addChild(levelArt);
		}
		
		/**
		 * This function loops through the layers of the level art and creates box2D bodies based on what we dragged into place.
		 * Fast level creation through the Flash IDE.
		 */
		private function parseLevelArt():void
		{
			var isWaterLevel:Boolean = false;
			objectsThatFloat = [];
			var target:b2Body
			for (var i:int = 0; i < levelArt.numChildren; i++) 
			{
				if (levelArt.getChildAt(i) is RectangleShape) {
					trace("Make Rectangle");
					addNewRectangle(levelArt.getChildAt(i));
				} else if (levelArt.getChildAt(i) is DynamicRectangle) {
					trace("Make Dynamic Rectangle");
					addNewDynamicRectangle(levelArt.getChildAt(i));
				} else if (levelArt.getChildAt(i) is CircleShape) {
					trace("Make Circle");
					addNewCircle(levelArt.getChildAt(i));
				} else if (levelArt.getChildAt(i) is DynamicCircleShape) {
					trace("Make Dynamic Circle");
					addNewDynamicCircle(levelArt.getChildAt(i));
				} else if (levelArt.getChildAt(i) is CompoundObject) {
					trace("Make CompoundShape");
					// This is how you would make an object made of several shapes if you wanted to.
					addNewCompoundShape(levelArt.getChildAt(i) as Sprite)
				}else if (levelArt.getChildAt(i) is FloatingObject) {
					// This is a special type fo compound shape: one that floats.
					trace("Floating Shape");
					objectsThatFloat.push(addPoolToy(levelArt.getChildAt(i) as Sprite));
				}else if (levelArt.getChildAt(i) is TargetHolder) {
					trace("Make Target");
					target = addTargetHolder(levelArt.getChildAt(i) as Sprite);
				} else if (levelArt.getChildAt(i) is Cannon) {
					// Tell the ball launcher what Sprite to use.
					ballLauncher.art = levelArt.getChildAt(i) as Cannon;
				} else if (levelArt.getChildAt(i) is Water) {
					isWaterLevel = true;
					buoyancyController.offset = -levelArt.getChildAt(i).y / m_physScale;
				} else if (levelArt.getChildAt(i) is Bonus) {
					trace("Make Bonus");
					addNewBonus(levelArt.getChildAt(i) as Sprite);
				}
			}
			if (isWaterLevel) {
				// For water levels, there are additional variables to set.
				target.SetType(b2Body.b2_dynamicBody);
				target.SetFixedRotation(false);
				objectsThatFloat.push(target);
				for (var j:int = 0; j < objectsThatFloat.length; j++) 
				{
					var b:b2Body = objectsThatFloat[j];
					buoyancyController.AddBody(b);
				}
				m_world.AddController(buoyancyController);
			} else {
				// This si called if it is not a water elvel.
				target.SetType(b2Body.b2_dynamicBody);
				m_world.RemoveController(buoyancyController);
			}
			// Clean up the reference to target. We don't need it anymore.
			target = null;
		}
		
		private function addPoolToy(toy:Sprite):b2Body
		{
			trace("-toy Added");
			var toyDef:b2BodyDef = new b2BodyDef();
			var toyBody:b2Body = m_world.CreateBody(toyDef);
			var scaleXModifier:Number = toy.scaleX;
			var scaleYModifier:Number = toy.scaleY;
			for (var i:int = 0; i < toy.numChildren; i++) 
			{
				var art:DisplayObject = toy.getChildAt(i);
				if (art is RectangleShape) {
					trace("--toyrect Added");
					art.visible = false;
					var rectDef:b2BodyDef
					var rect:b2PolygonShape = new b2PolygonShape();
					trace(" art.rotation", art.rotation, Utilities.degreesToRadians(art.rotation));
					rect.SetAsOrientedBox(art.width / m_physScale / 2 * scaleXModifier, art.height / m_physScale / 2 * scaleYModifier, new b2Vec2(art.x / m_physScale * scaleXModifier, art.y / m_physScale * scaleYModifier), 2 * Utilities.degreesToRadians(art.rotation));
					var fx:b2FixtureDef = new b2FixtureDef();
					fx.friction = 1;
					fx.density = 0.5;
					fx.shape = rect;
					toyBody.CreateFixture(fx);
				} else if (art is CircleShape) {
					trace("--toycirc Added");
					//NOTE CIRCLES WILL NOT SCALE non-proportionally
					art.visible = false;
					var circ:b2CircleShape = new b2CircleShape(art.width / 2 / m_physScale* scaleXModifier);
					circ.SetLocalPosition(new b2Vec2(art.x / m_physScale * scaleXModifier, art.y / m_physScale * scaleYModifier));
					var cfx:b2FixtureDef = new b2FixtureDef();
					cfx.friction = 1;
					cfx.density = 0.5;
					cfx.shape = circ;
					toyBody.CreateFixture(cfx);
				}
				
			}
			toyBody.SetPositionAndAngle(new b2Vec2(toy.x / m_physScale, toy.y / m_physScale), Utilities.degreesToRadians(toy.rotation));			
			toyBody.SetType(b2Body.b2_dynamicBody); // uncomment to make toys movable.
			return toyBody;
		}
		
		private function addTargetHolder(targetArt:Sprite):b2Body
		{
			var targetDef:b2BodyDef = new b2BodyDef();
			var targetBody:b2Body = m_world.CreateBody(targetDef);
			var scaleXModifier:Number = targetArt.scaleX;
			var scaleYModifier:Number = targetArt.scaleY;
			for (var i:int = 0; i < targetArt.numChildren; i++) 
			{
				var art:DisplayObject = targetArt.getChildAt(i);
				if (art is RectangleShape) {
					trace("--ballsArrayrect Added");
					//art.visible = false;
					var rect:b2PolygonShape = new b2PolygonShape();
					trace(" art.rotation", art.rotation, Utilities.degreesToRadians(art.rotation));
					rect.SetAsOrientedBox(art.width / m_physScale / 2 * scaleXModifier, art.height / m_physScale / 2 * scaleYModifier, new b2Vec2(art.x / m_physScale* scaleXModifier, art.y / m_physScale * scaleYModifier), 2*Utilities.degreesToRadians(art.rotation));
					targetBody.CreateFixture2(rect);
				} else if (art is TriggerShape) {
					//art.visible = false;
					var trigger:b2PolygonShape = new b2PolygonShape();
					trigger.SetAsOrientedBox(art.width / m_physScale / 2 * scaleXModifier, art.height / m_physScale / 2 * scaleYModifier, new b2Vec2(art.x / m_physScale * scaleXModifier, art.y / m_physScale * scaleYModifier), 2 * Utilities.degreesToRadians(art.rotation));
					var fx:b2FixtureDef = new b2FixtureDef();
					fx.isSensor = true;
					fx.shape = trigger;
					targetBody.CreateFixture(fx);
					targetBody.SetUserData( { name:"target" } );
				} 
			}
			ballsArray.push( { art:targetArt, body:targetBody} );
			targetBody.SetFixedRotation(false);
			targetBody.SetPositionAndAngle(new b2Vec2(targetArt.x / m_physScale, targetArt.y / m_physScale), Utilities.degreesToRadians(targetArt.rotation));
			
			return targetBody;
		}
		
		private function addNewCompoundShape(body:Sprite):void
		{
			trace("-ballsArray Added");
			var bodyDef:b2BodyDef = new b2BodyDef();
			var bodyBody:b2Body = m_world.CreateBody(bodyDef);
			var scaleXModifier:Number = body.scaleX;
			var scaleYModifier:Number = body.scaleY;
			for (var i:int = 0; i < body.numChildren; i++) 
			{
				var art:DisplayObject = body.getChildAt(i);
				if (art is RectangleShape) {
					trace("--bodyrect Added");
					art.visible = false;
					var rectDef:b2BodyDef
					var rect:b2PolygonShape = new b2PolygonShape();
					trace(" art.rotation", art.rotation, Utilities.degreesToRadians(art.rotation));
					rect.SetAsOrientedBox(art.width / m_physScale / 2 * scaleXModifier, art.height / m_physScale / 2 * scaleYModifier, new b2Vec2(art.x / m_physScale * scaleXModifier, art.y / m_physScale * scaleYModifier), 2 * Utilities.degreesToRadians(art.rotation));
					var fx:b2FixtureDef = new b2FixtureDef();
					fx.friction = 1;
					fx.density = 0;
					fx.shape = rect;
					bodyBody.CreateFixture(fx);
				} else if (art is CircleShape) {
					art.visible = false;
					trace("--bodycirc Added");
					//NOTE CIRCLES WILL NOT SCALE non-proportionally
					var circ:b2CircleShape = new b2CircleShape(art.width / 2 / m_physScale* scaleXModifier);
					circ.SetLocalPosition(new b2Vec2(art.x / m_physScale * scaleXModifier, art.y / m_physScale * scaleYModifier));
					var cfx:b2FixtureDef = new b2FixtureDef();
					cfx.friction = 1;
					cfx.density = 0;
					cfx.shape = circ;
					bodyBody.CreateFixture(cfx);
				}
				
			}
			bodyBody.SetPositionAndAngle(new b2Vec2(body.x / m_physScale, body.y / m_physScale), Utilities.degreesToRadians(body.rotation));			
			//bodyBody.SetType(b2Body.b2_dynamicBody); // uncomment to make bodies movable.
			
		}
		
		/**
		 * Rectangle Factory
		 * Places a rectangle body in the world at the scaled position of the given display Objects
		 * @param	art
		 */
		
		private function addNewRectangle(art:DisplayObject):void
		{
			art.visible = false;
			var bd:b2BodyDef = new b2BodyDef();
			bd.position.Set(art.x/ m_physScale, art.y/ m_physScale);
			var angle:Number = Utilities.degreesToRadians(art.rotation);
			var rect:b2PolygonShape = new b2PolygonShape();
			art.rotation = 0;
			rect.SetAsOrientedBox(art.width / m_physScale / 2, art.height / m_physScale / 2, new b2Vec2(), angle);
			var body:b2Body = m_world.CreateBody(bd);
			var fx:b2FixtureDef = new b2FixtureDef();
			fx.friction = 1;
			fx.density = 0;
			fx.shape = rect;
			body.CreateFixture(fx);
			trace("added rectangle", body);
		}

		private function addNewDynamicRectangle(art:DisplayObject):void
		{
			art.visible = false;
			var bd:b2BodyDef = new b2BodyDef();
			bd.position.Set(art.x/ m_physScale, art.y/ m_physScale);
			var angle:Number = Utilities.degreesToRadians(art.rotation);
			art.rotation = 0;
			var rect:b2PolygonShape = new b2PolygonShape();
			rect.SetAsOrientedBox(art.width / m_physScale / 2, art.height / m_physScale / 2, new b2Vec2(), angle);
			var body:b2Body = m_world.CreateBody(bd);
			var fx:b2FixtureDef = new b2FixtureDef();
			fx.friction = 1;
			fx.density = 1;
			fx.shape = rect;
			body.CreateFixture(fx);
			body.SetType(b2Body.b2_dynamicBody);
			body.SetFixedRotation(false);
			trace("added rectangle", body);
		}
		
		private function addNewCircle(art:DisplayObject):void
		{   
			art.visible = false;
			var bd:b2BodyDef = new b2BodyDef();
			var circ:b2CircleShape = new b2CircleShape(art.width / 2 / m_physScale);
			circ.SetLocalPosition(new b2Vec2(art.x / m_physScale, art.y / m_physScale));
			var cfx:b2FixtureDef = new b2FixtureDef();
			cfx.friction = 1;
			cfx.density = 0;
			cfx.shape = circ;
			var body:b2Body = m_world.CreateBody(bd);
			body.CreateFixture(cfx);
		}

		private function addNewDynamicCircle(art:DisplayObject):void
		{   
			art.visible = false;
			var bd:b2BodyDef = new b2BodyDef();
			var circ:b2CircleShape = new b2CircleShape((art.width / 2) / m_physScale);
			circ.SetLocalPosition(new b2Vec2(art.x / m_physScale, art.y / m_physScale));
			var cfx:b2FixtureDef = new b2FixtureDef();
			cfx.friction = 1;
			cfx.density = 1;
			cfx.shape = circ;
			var body:b2Body = m_world.CreateBody(bd);
			body.SetFixedRotation(false);
			body.SetType(b2Body.b2_dynamicBody);
			body.CreateFixture(cfx);
		}
		
		private function addNewBonus(art:Sprite):void
		{
			trace("addingBonus");
			for (var i:int = 0; i < art.numChildren; i++) 
			{
				if (art.getChildAt(i) is CircleShape) {
					trace("add bonus Circle");
					var a:DisplayObject = art.getChildAt(i) ;
					a.visible = false;
					var bd:b2BodyDef = new b2BodyDef();
					var circ:b2CircleShape = new b2CircleShape(((a.width*art.scaleX) / 2)/ m_physScale);
					circ.SetLocalPosition(new b2Vec2(art.x / m_physScale, art.y / m_physScale));
					var cfx:b2FixtureDef = new b2FixtureDef();
					cfx.isSensor = true;
					cfx.shape = circ;
					var body:b2Body = m_world.CreateBody(bd);
					body.CreateFixture(cfx);
					body.SetUserData( { name:"bonus", art:art } );
				}
			}
		}

		public function get levelComplete():Boolean { return _levelComplete; }
		
		public function set levelComplete(value:Boolean):void 
		{
			_levelComplete = value;
			if(_levelComplete){
				trace("Win!", value)
				dispatchEvent(new Event(LEVEL_COMPLETE));
				var s:Sound = new TargetHitSound();
				s.play();
			}
		}		
		
	}

}