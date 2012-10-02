package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.devices.messages.Touch;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.TouchEvent;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	[SWF(width="768", height="768")]
	public class SampleDemo extends Sprite
	{
		public var delta:Number=new Date().time;
		public var bm:BMApplication;
		public var curesor:Reticle=new Reticle;
		public var appScheme:AppScheme;
		public function SampleDemo()
		{
		

			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Sample demo", 1);
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			bm.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onUnLoaded);
			
			stage.frameRate=60;
			
			var sq:SampleDemoScheme=new SampleDemoScheme();
			


			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(sq,false,false,'landscape' );
			
			//Get and remove the rectangles we will stretch the graphics to.
			var image1:AppDisplayObject= appScheme.removeChildByName("stretchTo1");
			var image2:AppDisplayObject= appScheme.removeChildByName("stretchTo2");
			// get the item and apply the sample mode and rectangle
			var linear:AppDisplayObject= appScheme.getChildByName("linear");
			linear.sample=AppDisplayObject.LINEAR;
			linear.rect=image1.rect;
			// get the item and apply the sample mode and rectangle
			var nearest:AppDisplayObject= appScheme.getChildByName("nearest");
			nearest.sample=AppDisplayObject.NEAREST;
			nearest.rect=image2.rect;
			
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
			var now:Number=new Date().time;
			trace((now-delta));
			delta=now
			
			for each (var touch:Touch in de.touches.touches)
			{
				//trace(curesor.x,touch.y,touch.phase.toString());
				curesor.y=touch.y;
				curesor.x=touch.x;
			}
		}		
		public function onLoaded(de:DeviceEvent):void
		{
			de.device.addEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);
			flash.utils.setTimeout(bm.session.setTouchInterval,200,de.device,1/15);
			//bm.session.setTouchInterval(de,1/24);
		}
		

		public function onUnLoaded(de:DeviceEvent):void
		{
			de.device.removeEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);
			
		}
	}
}