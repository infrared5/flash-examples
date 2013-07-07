package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMDPad;
	import com.brassmonkey.controls.writer.StageScaler;
	import com.brassmonkey.events.DeviceEvent;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScreenSizes extends Sprite
	{
		private var lan:BMApplication;
		
		public function ScreenSizes()
		{
			lan=new BMApplication(loaderInfo.parameters);
			lan.initiate("BootCamp",3,"4bf5ac7fb9982495864209da55f04e9c");
			lan.addEventListener(DeviceEvent.DEVICE_CONNECTED, onConnected);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);			
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
	
			var rect:Rectangle;
			var dpd:BMDPad = new BMDPad();			
			// Screen Sizes
			
			//Default 480 320 			

			//We use the BMControls factory to parse all the chidren of that movie clip, preparing the image data for export.
			var defaultScheme:AppScheme=BMControls.parseDynamicMovieClip(new DefaultScreen(),false,true,"landscape",480,320,AppDisplayObject.LINEAR);
			//remove dpad rectangle place holder movie clip and get the rect.
			 rect = defaultScheme.removeChildByName("dpad").rect;				
			//set scheme frame/page.(defualt is 1) 
			dpd.page=1;
			//apply rect to dpad.
			dpd.hitRect=rect;
			dpd.rect=rect;			
			//alter the % of the middle dead zone between 0 and 1.
			dpd.deadZone=.25;
			//add dpad to scheme. 
			defaultScheme.addChild(dpd);
			//add it in.
			lan.session.registry.validateAndAddControlXML(defaultScheme.toString());			

			// Samsung GT-P3113 or equivalent.
			
			//set the screen pixel size
			StageScaler.LONG=976;
			StageScaler.SHORT=600;
			// clear graphics registry. This insures that this new XML is not referencing the resources on the other XML.
			AppScheme.clearRegistry();
			
			var gTabScheme:AppScheme=BMControls.parseDynamicMovieClip(new GalaxyScreen(),false,true,"landscape",976,600,AppDisplayObject.LINEAR);
			//remove dpad rectangle place holder movie clip and get the rect.
			rect=gTabScheme.removeChildByName("dpad").rect;
			dpd.hitRect=rect;
			dpd.rect=rect;			
			//alter the % of the middle dead zone between 0 and 1.
			dpd.deadZone=.25;
			gTabScheme.addChild(dpd);			
			
			lan.session.registry.validateAndAddControlXML(gTabScheme.toString());			
			
			
			
			//set the screen pixel size
			StageScaler.LONG=1024;
			StageScaler.SHORT=768;
			// clear graphics registry. This insures that this new XML is not referencing the resources on the other XML.
			AppScheme.clearRegistry();
			
			//We use the BMControls factory to parse all the chidren of that movie clip, preparing the image data for export.
			var ipad2:AppScheme=BMControls.parseDynamicMovieClip(new IOSScreen(),false,true,"landscape",1024,768,AppDisplayObject.LINEAR);
			
			rect =ipad2.removeChildByName("dpad").rect;

			//set scheme frame/page. 
			dpd.page=1;
			//apply rects.
			dpd.hitRect=rect;
			dpd.rect=rect;			
			//alter the % of the middle dead zone between 0 and 1.
			dpd.deadZone=.25;
			ipad2.addChild(dpd);
			
			lan.session.registry.validateAndAddControlXML(ipad2.toString());
		
		
		
			lan.start();
		
		}
		
		protected function onConnected(event:DeviceEvent):void
		{
			event.device.removeEventListener(DeviceEvent.DEVICE_CONNECTED, onConnected);
			event.device.addEventListener(DeviceEvent.CAPABILITIES, onCapabilities);
			
		}
		
		protected function onCapabilities(event:DeviceEvent):void
		{
			event.device.removeEventListener(DeviceEvent.CAPABILITIES, onCapabilities);
			
			var w:Number=event.device.capabilities.screenWidth ;
			var h:Number=event.device.capabilities.screenHeight ;
			
			if(w > h )
			{//is listed native as  landscape, typical
				if(w == 1024 && h==768 )//ipad
				{
					event.device.controlSchemeIndex=2;
				} 
				else if(w == 976 && h==600)//GT-3113
				{
					event.device.controlSchemeIndex=1;
				}
				else//itouch/iphone
				{
					event.device.controlSchemeIndex=0;
				}
					
			}
			else
			{//is listed native as portrait
				if(h == 1024 && w == 768 )//unknown
				{
					event.device.controlSchemeIndex=2;
				} 
				else if(h == 976 && w==600)//unknown
				{
					event.device.controlSchemeIndex=1;
				}
				else//unknown
				{
					event.device.controlSchemeIndex=0;
				}
			}
			
		}
		
		protected function onDevice(event:DeviceEvent):void
		{
			lan.removeEventListener(DeviceEvent.DEVICE_LOADED, onDevice);		
			
		}
		

	}
}