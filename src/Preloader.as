package 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Preloader extends MovieClip 
	{
		[Embed(source = '../lib/preloader.swf', symbol = 'progressbar')]
		private var progressBarClass:Class
		[Embed(source = '../lib/preloader.swf', symbol = 'percent')]
		private var percentDisplayClass:Class
		
		private var preloadGraphic:Sprite = new Sprite();
		private var progressBar:Sprite = new progressBarClass();
		private var percentDisplay:Sprite = new percentDisplayClass();
		private var percent:TextField;
	
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			// show loader
			progressBar.scaleX = 0;
			preloadGraphic.addChild(progressBar);
			preloadGraphic.addChild(percentDisplay);
			preloadGraphic.y = stage.stageHeight / 2;
			percentDisplay.blendMode = BlendMode.INVERT;
			percentDisplay.x = stage.stageWidth / 2;
			percentDisplay.y = -4;
			percent = percentDisplay.getChildByName("percentDisplay") as TextField;
			addChild(preloadGraphic);
			
		}
		
		private function checkFrame(e:Event):void 
		{
			// update loader
			trace(e);
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			} else {
				var bytesLoaded:Number = this.loaderInfo.bytesLoaded;
				var bytesTotal:Number = this.loaderInfo.bytesTotal;
				percent.text = Math.ceil((100 * (bytesLoaded / bytesTotal))) + "%";
				progressBar.scaleX = (bytesLoaded / bytesTotal);
			}
		}
		
		private function startup():void 
		{
			// hide loader
			removeChild(preloadGraphic);
			stop();
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}