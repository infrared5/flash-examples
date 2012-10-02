package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMDynamicText;
	import com.brassmonkey.controls.writer.BMImage;
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
	public class ButtonHitRects extends Sprite
	{

		public var bm:BMApplication;
		public var cursor:Reticle=new Reticle;
		public var appScheme:AppScheme;
		
		public function ButtonHitRects()
		{

			addChild(new SquareScheme());
			addChild(cursor);
			stage.frameRate=60;
			
			//initiate brassmonkey
			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Hit rects", 1);
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			bm.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onUnLoaded);
			
			// A square scheme to be held in landscape mode.
			var sq:SquareScheme=new SquareScheme();
			//set the scaler to the screen size the controls were created for.
			StageScaler.LONG=768;			
			StageScaler.SHORT=768;
			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(sq,false,true,'landscape',768,768 );

			var button:BMButton= appScheme.getChildByName("select") as BMButton;
			
			var image:BMImage = appScheme.getChildByName("testRect") as BMImage
			//apply a new larger hit rect to the button.
			button.hitRect=image.rect;
	
			// Add controls to the list of schemes.
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			bm.start();

			bm.session.getSlotDisplay().x=20;
			bm.session.getSlotDisplay().y=20;
			
			addChild(bm.session.getSlotDisplay());
		}
		
		public function onTouch(de:TouchEvent):void
		{	
			for each (var touch:Touch in de.touches.touches)
			{
				if(touch.phase==TouchPhase.ENDED)
					return;
				//move the cursor
				cursor.y=touch.y;
				cursor.x=touch.x;
			}
		}
		
		public function onLoaded(de:DeviceEvent):void
		{
			//subscibe to touch events.
			de.device.addEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);		
			//set the touch frequency.
			bm.session.setTouchInterval(de.device,1/24);

		}

		public function onUnLoaded(de:DeviceEvent):void
		{
			de.device.removeEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);
			
		}
	}
}