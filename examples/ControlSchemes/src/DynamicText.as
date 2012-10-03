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
	import com.brassmonkey.devices.DeviceCapabilities;
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
			//add the scheme 	
			addChild(new TextDemoScheme());
			addChild(cursor);
			stage.frameRate=60;
			
			//initiate brassmonkey
			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Dynamic Text", 4);
			//We want to add additional hanlders for customized scheme creation.			
			bm.addEventListener(DeviceEvent.DEVICE_CONNECTED , onConnected);
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			bm.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onUnLoaded);
			
			//Typically, control schemes are created here, but in this demo,  
			//we will generated them on the fly as devices connect.
			
			// GO!
			bm.start();
			
			bm.session.getSlotDisplay().x=10;
			bm.session.getSlotDisplay().y=10;
			
			//add the slot color.
			addChild(bm.session.getSlotDisplay());
		}
		
		protected function onConnected(event:DeviceEvent):void
		{
			trace("onConnected");	
			//on this event , we can know the device pixel resolution and orientation/gyroscope support.
			event.device.addEventListener(DeviceEvent.CAPABILITIES, onCapabilities);
			//after that will come the formal request for the control data.
			event.device.addEventListener(DeviceEvent.CONTROL_SCHEME_REQUEST, onSchemeRequest);
		}		
		
		protected function onSchemeRequest(event:DeviceEvent):void
		{
			trace("onSchemeRequest");
			// A simple scheme to be held in landscape mode.
			var mc:TextDemoScheme=new TextDemoScheme();
			
			//we have a static text field that will use embedded fonts because it is not a direct child of the control scheme clip.
			//It cannot be edited at client-runtime unless you re-serialize it again, and replace the old image data with the new. 
			mc.embededFontContainer.embedded.text = event.device.deviceName;
			
			
			//we have child text field that will become dynamic because it is on the root of the control scheme clip, 
			//and it is named.
			mc.dynamicText.text="Hello "+event.device.deviceName;
			
			//make sure its named so it is drawn into the control scheme.
			bm.session.getSlotDisplay().name="slotColor";
			//Just for added fun, we will add the host slot color to the control pad.
			mc.addChild(bm.session.getSlotDisplay());
			
			//When generating customized versions of the same display objects, you must allow re-encoding 
			// to utilize the automated serialization on them. 
			AppScheme.ALLOW_REENCODING=true;
			
			//parse the scheme, and add the actual design orientation, width and height.
			var appScheme:AppScheme = BMControls.parseDynamicMovieClip(mc,false,true,'landscape',480,320, AppDisplayObject.NEAREST);
			//add it to the session.
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
			
			//designate the specific scheme index that will be sent 
			//to the client in the initial connection process.
			event.device.controlSchemeIndex = bm.session.registry.controlSchemes.length -1; 
			
			//show our slot color.
			addChild(bm.session.getSlotDisplay());
		}
		
		protected function onCapabilities(event:DeviceEvent):void
		{
			var capps:DeviceCapabilities =  event.device.capabilities;
			
			trace("onCapabilities:",capps.screenWidth, capps.screenHeight,", gyro support:", capps.hasGyroscope,", orientation support:", capps.hasOrientation);
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
			trace("onLoaded");
			//device is fully loaded and ready for scripting			
			//subscibe to touch events.
			de.device.addEventListener(TouchEvent.TOUCHES_RECEIVED, onTouch);				
			//set the touch frequency.
			bm.session.setTouchInterval(de.device,1/24);

			//send update to all connected clients.
			notifyClients();
		}
		
		protected function onUnLoaded(event:DeviceEvent):void
		{
			trace("onUnLoaded");
			//send update to connected clients.
			notifyClients();
		}
		
		/**
		 * This updates the dynamic text on the control pad with the current number of connected clients. 
		 * 
		 */		
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