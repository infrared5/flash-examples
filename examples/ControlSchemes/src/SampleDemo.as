package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.StageScaler;
	import com.brassmonkey.devices.messages.Touch;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.TouchEvent;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	[SWF(width="768", height="768")]
	public class SampleDemo extends Sprite
	{
		
		public var bm:BMApplication;		
		public var appScheme:AppScheme;
		private var _page:int = 1;
		
		public function SampleDemo()
		{
		

			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Sample demo", 1);
			//respond to device loaded events to add button handlers.
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			
			
			stage.frameRate=60;
			
			var sq:TinyScheme = new TinyScheme();
			
			//the stage scaler is to set the size of the screen that the controls are designed for.
			StageScaler.LONG = 98;
			StageScaler.SHORT = 64;
			//The vallues used for width and height when parsing the movie clip is the displayed size within the screen size.			
			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(sq,false,false,'portrait', 64,98, AppDisplayObject.NEAREST);
			// on the second frame, there is a object we will specify as linear to show the difference it makes.
			appScheme.getChildByName("buttonB").sample = AppDisplayObject.LINEAR;
			// Add controls to the list of schemes.
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			bm.start();
		
			bm.session.getSlotDisplay().x=20;
			bm.session.getSlotDisplay().y=20;
			addChild(bm.session.getSlotDisplay());
		}

		
		public function onLoaded(de:DeviceEvent):void
		{
			//add handler for toggling between nearest and linear sampl modes.
			de.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButton);	
		}
		
		protected function onButton(event:DeviceEvent):void
		{
			trace(appScheme.pageToString(1));
			if( event.value.state=="up" )
			{
				_page= _page==1?2:1;
				//page 2 is linear, page one is nearest.
				bm.session.updateControlScheme(event.device, appScheme.pageToString(_page));
			}
			
		}		

	}
}