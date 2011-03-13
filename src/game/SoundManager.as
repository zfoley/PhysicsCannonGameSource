package game 
{

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class SoundManager 
	{
		private static var backgroundMusic:Sound
		private static var musicChannel:SoundChannel
		private static var musicPlayProgress:Number = 0;
		private static var engineHum:Sound;
		private static var engineHumChannel:SoundChannel;
		static public const MUTE_ALL_SOUNDS:String = "muteAllSounds";
		static public const UNMUTE_ALL_SOUNDS:String = "unmuteAllSounds";
		static public const HIT_SOUND:String = "hitSound";
		static public const MISS_SOUND:String = "missSound";
		static public const REPAIR_SOUND:String = "repairSound";
		static public const WARNING_SOUND:String = "warningSound";
		static public const BUTTON_OVER_SOUND:String = "buttonOver";
		static public const BUTTON_PRESS_SOUND:String = "buttonPress";
		static private var _muted:Boolean
		
		public function SoundManager() 
		{
		}
		public static function muteSound():void {
			SoundMixer.soundTransform = new SoundTransform(0);
			_muted = true;
		}
		public static function unMuteSound():void {
			SoundMixer.soundTransform = new SoundTransform(1);
			_muted = false;
		}
		public static function playSound(soundName:String):Boolean {
			var soundClass:Class = getDefinitionByName(soundName) as Class;
			var sound:Sound = new soundClass();
			if(sound != null){
				var soundChannel:SoundChannel = sound.play()
				return true;
			} 
			return false;
		}
		public static function startMusic():void {
			
			//var musicClass:* = new musicLoop();
			//trace("MusicClass =", musicClass);
			backgroundMusic = new musicLoop();
			musicChannel = backgroundMusic.play(0.1, 999);
			musicChannel.soundTransform = new SoundTransform(0.0);
			musicChannel.addEventListener(Event.SOUND_COMPLETE, onMusicComplete)
		}
		public static function stopMusic():void {
			trace("MUSICCHANNEL STOP", "SoundManager");
			musicChannel.stop();
		}
		static private function onMusicComplete(e:Event):void 
		{
			startMusic();
		}
		public static function pauseMusic():void {
			if(musicChannel == null){return}
			musicPlayProgress = musicChannel.position;
			musicChannel.stop();
			
		}
		public static function resumeMusic():void {
			try{
				musicChannel = backgroundMusic.play(musicPlayProgress, 0);
				musicChannel.addEventListener(Event.SOUND_COMPLETE, onMusicComplete)
			}catch (e:Error) {
				startMusic();
			}
		}
		
		static public function get muted():Boolean { return _muted; }
		
	}
	
}