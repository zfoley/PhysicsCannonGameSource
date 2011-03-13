package game 
{
	
	/**
	 * ...
	 * Game Hearbeat is a static implementation of EventDispatcher to allow entites with no direct knowledge of each other to dispatch and listen for events.
	 * 
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class StaticEventRepeater 
	{
		private static var eventDispatcher			: EventDispatcher;
		
	
		/**
		 * Broadcasts an event to all listeners
		 * Broadcaster.addEventListener(eventType, listenerFunction, useCapture);
		 *
		 * @param	event		The Event to broadcast
		 * @return				nothing
		 */
		public static function broadcast( event:Event ): void
		{
			dispatchEvent( event );
		}


		public static function addEventListener( type:String, listener:Function, useCapture:Boolean=false,
			priority:int=0, useWeakReference:Boolean=true ):void
		{
			if ( !eventDispatcher ) eventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public static function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void
		{
			if ( eventDispatcher ) eventDispatcher.removeEventListener( type, listener, useCapture );
  	    	}

		public static function dispatchEvent( p_event:Event ):void
		{
			if ( eventDispatcher ) eventDispatcher.dispatchEvent( p_event );
		}

	}
}

		

