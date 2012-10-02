package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
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
	
	[SWF(width="480", height="320")]
	public class ButtonHitRects extends Sprite
	{

		public var bm:BMApplication;
		public var cursor:Reticle=new Reticle;
		public var appScheme:AppScheme;
		
		public function ButtonHitRects()
		{

			
			
			
			addChild(new HitRectDemoScheme());
			addChild(cursor);
			stage.frameRate=60;
			
			//initiate brassmonkey
			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Hit rects", 1);
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
		
			
			// A square scheme to be held in landscape mode.
			var sq:HitRectDemoScheme=new HitRectDemoScheme();

			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(sq,false,true,'landscape',480,320, AppDisplayObject.NEAREST);
			var bmImageL:BMImage = appScheme.removeChildByName("leftRect") as BMImage;
			var bmImageR:BMImage = appScheme.removeChildByName("rightRect") as BMImage;
			
			var buttonL:BMButton= appScheme.getChildByName("left") as BMButton;			
			var buttonR:BMButton = appScheme.getChildByName("right") as BMButton
			//apply a new larger hit rect to the button.
			buttonL.hitRect=bmImageL.rect;
			buttonR.hitRect=bmImageR.rect;
			// Add controls to the list of schemes.
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			bm.start();

			bm.session.getSlotDisplay().x=10;
			bm.session.getSlotDisplay().y=10;
			
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

	}
}