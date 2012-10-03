package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.BrassMonkey;
	import com.brassmonkey.SettingsManager;
	import com.brassmonkey.controls.BMControlAsset;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMDynamicText;
	import com.brassmonkey.controls.writer.StageScaler;
	import com.brassmonkey.devices.Device;
	import com.brassmonkey.devices.messages.Touch;
	import com.brassmonkey.devices.messages.TouchPhase;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.TouchEvent;
	
	import flash.display.Sprite;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	[SWF(width="768", height="768")]
	public class AspectRatio extends Sprite
	{
	
		public var lan:BMApplication;
		public var cursor:Reticle=new Reticle;
		public var appScheme:AppScheme;
		
		public function AspectRatio()
		{
			//add a copy of the control scheme for visual feedback.
			addChild(new SquareScheme());
			//add a touch indicator
			addChild(cursor);
			//initiate the brassmonkey interface
			lan= new BMApplication(loaderInfo.parameters);
			lan.initiate("Aspect ratio", 1);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onUnLoaded);
			
			stage.frameRate=60;
			// A square scheme to be held in landscape mode.
			var sq:SquareScheme=new SquareScheme();
			//set the scaler to the screen size the controls were createde for.
			StageScaler.LONG=768;			
			StageScaler.SHORT=768;
			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(sq,false,true,'landscape',768,768 );
			// Add controls to the list of schemes.
			lan.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			lan.start();
			
			lan.session.getSlotDisplay().x=20;
			lan.session.getSlotDisplay().y=20;
			addChild(lan.session.getSlotDisplay());
		}
		
		public function onTouch(de:TouchEvent):void
		{
			for each (var touch:Touch in de.touches.touches)
			{
				if(touch.phase == TouchPhase.ENDED)
					return;
				
				cursor.y=touch.y;
				cursor.x=touch.x;
			}
		}	
		
		public function onLoaded(de:DeviceEvent):void
		{
			de.device.addEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);		
			lan.session.setTouchInterval(de.device,1/24);
		}

		public function onUnLoaded(de:DeviceEvent):void
		{
			de.device.removeEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);
		}
	}
}