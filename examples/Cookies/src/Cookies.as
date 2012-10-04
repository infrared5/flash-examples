package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.SettingsManager;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.events.DeviceEvent;
	
	import flash.display.Sprite;
	
	[SWF(width="480", height="320")]
	public class Cookies extends Sprite
	{
		
		public var lan:BMApplication;
				
		public function Cookies()
		{
			addChild(new MonsterTruckControlScheme());
			
			stage.frameRate=60;
			SettingsManager.SOCKET_SERVER_ADDRESS = "qaregistry.monkeysecurity.com";
			//initiate brassmonkey
			lan= new BMApplication(loaderInfo.parameters);
			lan.initiate("Cookies", 1);
			//We want to add additional hanlders for touch and button events.
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			
			
			// A simple scheme to be held in landscape mode.
			var sq:MonsterTruckControlScheme=new MonsterTruckControlScheme();
			
			//parse the scheme, and add the actual design orientation, width and height.
			var appScheme:AppScheme = BMControls.parseDynamicMovieClip(sq,false,true,
					'landscape',480,320, AppDisplayObject.NEAREST);
			//we will remove the hit rect reference display objects from the control pad design, 
			//but then assign their rectangles to the buttons.
			var bmImageB:BMImage = appScheme.removeChildByName("hitrectBrake") as BMImage;			
			var bmImageG:BMImage = appScheme.removeChildByName("hitrectGas") as BMImage;
			var bmImageR:BMImage = appScheme.removeChildByName("hitrectR") as BMImage;
			var bmImageF:BMImage = appScheme.removeChildByName("hitrectF") as BMImage;
			//Grab the  references by name. 
			var brake:BMButton= appScheme.getChildByName("brake") as BMButton;			
			var gas:BMButton = appScheme.getChildByName("gas") as BMButton;
			var forward:BMButton= appScheme.getChildByName("forward") as BMButton;			
			var reverse:BMButton = appScheme.getChildByName("reverse") as BMButton;			
			//apply the new larger hit rect to the buttons.
			brake.hitRect=bmImageB.rect;
			gas.hitRect=bmImageG.rect;
			forward.hitRect=bmImageF.rect;
			reverse.hitRect=bmImageR.rect;
			// Add controls to the brassmonkey session.
			lan.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			lan.start();
			
			lan.session.getSlotDisplay().x=10;
			lan.session.getSlotDisplay().y=10;
			//add the slot color.
			addChild(lan.session.getSlotDisplay());
		}
	
		public function onLoaded(de:DeviceEvent):void
		{
			//subscibe to button events.		
			de.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButtonPress);
			de.device.addEventListener(DeviceEvent.GOT_COOKIE, onCookie);
		}
		
		protected function onCookie(event:DeviceEvent):void
		{		
			//All cookie values retrieved will be cached in 
			//the device attributes property.
			//trace them out			
			for(var prop:String in event.device.attributes)
			{
				trace("attribute -",prop,":", event.device.attributes[prop]);
			}
		}
		
		protected function onButtonPress(event:DeviceEvent):void
		{
			trace("on button event\t",event.value.name,event.value.state);
			
			if(event.value.name=="forward" && event.value.state=="up")
			{
				
				lan.session.setCookie(event.device, "somePropName","somePropVal"); 
			}
			else if(event.value.name=="reverse" && event.value.state=="up")
			{
				
				lan.session.getCookie(event.device, "somePropName");
			}
			else if(event.value.name=="brake" && event.value.state=="up")
			{
				
				event.device.attributes.localCookie = "yes";
			}
			else if(event.value.name=="gas" && event.value.state=="up")
			{
				
				event.device.attributes.localCookie = "moreCookie";
			}
		}
	}
}