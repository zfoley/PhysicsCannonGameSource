package game 
{
	/**
	 * ...
	 * @author Zach
	 */
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import flash.display.Sprite;

	public class ContactListener extends b2ContactListener
	{
		private var coingame:PhysicsGame;
		public static var CONTACT_MADE:Boolean = false;
		public function ContactListener(_coingame:PhysicsGame)
		{
			this.coingame = _coingame;
		}
		override public function BeginContact(contact:b2Contact):void 
		{
			super.BeginContact(contact);
			//if (contact.GetFixtureA().GetBody().GetUserData() == null || contact.GetFixtureB().GetBody().GetUserData() == null || contact.IsSensor()== false) {
				//return;
			//}
			if (contact.GetFixtureA().GetBody().GetUserData() == null || contact.GetFixtureB().GetBody().GetUserData() == null || contact.IsSensor() == false) {
				if(contact.GetFixtureA().GetBody().GetLinearVelocity().Length() > 5 || contact.GetFixtureB().GetBody().GetLinearVelocity().Length() > 5){
					CONTACT_MADE = true;
				}
				return;
			}
			var obj1:String = contact.GetFixtureA().GetBody().GetUserData().name;
			var obj2:String = contact.GetFixtureB().GetBody().GetUserData().name;
			if ((obj1 == "ball" && obj2 == "target" || obj1 == "target" && obj2 == "ball" ) && coingame.levelComplete == false) {
				coingame.levelComplete = true;
			} else if ((obj1 == "ball" && obj2 == "bonus" || obj1 == "bonus" && obj2 == "ball" ) && coingame.levelComplete == false) {
				var art:Sprite
				if (obj1 == "bonus") {
					art = contact.GetFixtureA().GetBody().GetUserData().art;
					contact.GetFixtureA().GetBody().SetUserData({name:"expiredtarget"});
				} else {
					art = contact.GetFixtureB().GetBody().GetUserData().art;
					contact.GetFixtureB().GetBody().SetUserData({name:"expiredtarget"});
				}
				coingame.handleBonusHit(art);
				
			}
		}
	}
}