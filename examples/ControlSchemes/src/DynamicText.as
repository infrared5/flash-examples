package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMDynamicText;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.devices.Device;
	import com.brassmonkey.devices.messages.Touch;
	import com.brassmonkey.devices.messages.TouchPhase;
	import com.brassmonkey.discovery.DeviceManager;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.TouchEvent;
	
	import flash.display.Sprite;
	
	[SWF(width="480", height="320")]
	public class DynamicText extends Sprite
	{
		
		public var bm:BMApplication;
		public var cursor:Reticle=new Reticle;
	
		
		public function DynamicText()
		{
			
			
			addChild(new TextDemoScheme());
			addChild(cursor);
			stage.frameRate=60;
			
			//initiate brassmonkey
			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Dynamic Text", 4);
			//We want to add additional hanlders for customized scheme creation.
			bm.addEventListener(DeviceEvent.DEVICE_AVAILABLE, onAvailable);
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			bm.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onUnLoaded);
			
			// GO!
			bm.start();
			
			bm.session.getSlotDisplay().x=10;
			bm.session.getSlotDisplay().y=10;
			//add the slot color.
			addChild(bm.session.getSlotDisplay());
		}
		

		
		protected function onAvailable(event:DeviceEvent):void
		{			
			if(bm.session.registry.devices.length>= bm.sessionInfo.maxClients){
				//ignore.
				return;
			}
			
			// A simple scheme to be held in landscape mode.
			var mc:TextDemoScheme=new TextDemoScheme();
			mc.embededFontContainer.embedded.text = event.device.deviceName;
			mc.dynamicText.text="Hello "+event.device.deviceName;
			
			bm.session.getSlotDisplay().name="slotColor";
			
			mc.addChild(bm.session.getSlotDisplay());
			
			AppScheme.ALLOW_REENCODING=true;
			//parse the scheme, and add the actual design orientation, width and height.
			var appScheme:AppScheme = BMControls.parseDynamicMovieClip(mc,false,true,'landscape',480,320, AppDisplayObject.NEAREST);
			
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
		
			event.device.controlSchemeIndex = bm.session.registry.controlSchemes.length -1; 
			
			addChild(bm.session.getSlotDisplay());
			
			bm.session.connectDevice(event.device);
			
		}
		/**
		 * Use touch events to move a cursor around. 
		 * @param de
		 * 
		 */		
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
			
			notifyClients();
			
		}
		
		protected function onUnLoaded(event:DeviceEvent):void
		{

			notifyClients();
			
		}
		private function notifyClients():void
		{
			var devices:Array = bm.session.registry.devices;
			
			for each(var device:Device in devices)
			{
				var index:int= device.controlSchemeIndex;
				var appScheme:AppScheme =BMControls.appSchemes[index];
				var bmText:BMDynamicText = appScheme.getChildByName("dynamicText") as BMDynamicText;
				bmText.text = "There are "+devices.length+" clients connected";
				bm.session.updateControlScheme(device ,appScheme.pageToString(1));
			}
		}
		
	}
}