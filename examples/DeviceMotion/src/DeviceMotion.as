package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.devices.messages.BMGyro;
	import com.brassmonkey.devices.messages.BMOrientation;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.ShakeEvent;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	[SWF(width="320", height="480")]
	public class DeviceMotion extends Sprite
	{
		//simple control scheme.
		public var pad:Pad = new Pad();
		//brassmonkey interface.
		public var lan:BMApplication
		//some output text fields.
		public var gText:TextField = new TextField();
		public var oText:TextField = new TextField();
		public var iText:TextField = new TextField();
		// an clip used to animate the aproximate position of the connected device.
		private var dev:RepClip=new RepClip();
		
		public function DeviceMotion()
		{

			addChild(dev);
			dev.x=160;
			dev.y=240
			//initiate the brassmonkey interface.
			lan=new BMApplication(loaderInfo.parameters);
			lan.initiate("Device Motion",1);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_CONNECTED, onDevice);
			//parse the control scheme clip. into portagble network graphics, using nearest neighbor sampling
			var scheme:AppScheme=BMControls.parseDynamicMovieClip(pad,false,false,"portrait",320,480, AppDisplayObject.NEAREST);
			//add the scheme to the brassmonkey session
			lan.session.registry.validateAndAddControlXML(scheme.toString());
			//start the session
			lan.start();
			//add the color indicator to the stage.
			addChild(lan.session.getSlotDisplay());
			
			//set up the info output display texts.
			oText.text="No Orientation support";
			oText.width = 300;;
			oText.textColor=0xff0000;
			oText.y=100;
			addChild(oText);
			
			gText.text="No Gyro support";			
			gText.textColor=0xff0000;
			gText.width=300;			
			gText.y=200;
			addChild(gText);
			
			iText.textColor=0xff0000;
			iText.width=300;
			iText.y=300;
			addChild(iText);
		}
		
		protected function onDevice(event:DeviceEvent):void
		{
			switch(event.type)
			{

				case DeviceEvent.DEVICE_LOADED:
					//display some device info about the screen capabilities.
					iText.text = " Screen width :" + event.device.capabilities.screenWidth + "  Screen height:" + event.device.capabilities.screenHeight  ;
					//listen for the device motion events. 
					event.device.addEventListener(ShakeEvent.SHAKE, onShake);					
					event.device.addEventListener(DeviceEvent.GYRO, onGyro);					
					event.device.addEventListener(DeviceEvent.ORIENTATION, onOrient);
					// enable gyro and orientation data streams.
					lan.session.enableGyro(event.device, true);
					lan.session.enableOrientation(event.device, true);
					lan.session.setOrientationInterval(event.device, 1/20);
					lan.session.setGyroInterval(event.device, 1/20);
					break;
				
				case DeviceEvent.DEVICE_DISCONNECTED:
					//remove event listeners
					event.device.removeEventListener(ShakeEvent.SHAKE, onShake);
					event.device.removeEventListener(DeviceEvent.GYRO, onGyro);					
					event.device.removeEventListener(DeviceEvent.ORIENTATION, onOrient);
					//reset info display text.	
					gText.text="No Gyro support";
					oText.text="No Orientation support";
					iText.text = " " ;
					break;
			}
			
		}
		
		protected function onOrient(event:DeviceEvent):void
		{
			//lets apply the device vectors to the animation 3d transform orientation vectors.
			var g:BMOrientation = event.value as BMOrientation ;
			var vects:Vector.<Vector3D> = dev._device.transform.matrix3D.decompose(Orientation3D.QUATERNION);
			var vect:Vector3D=new Vector3D();
			vects[1].w = g.w;
			vects[1].x = g.x;
			vects[1].y = g.y*-1;
			vects[1].z = g.z*-1;
			
			dev._device.transform.matrix3D.recompose(vects,Orientation3D.QUATERNION);
			//update info
			oText.text="Orientation- "+g.x.toFixed(2)+" "+g.y.toFixed(2)+" "+g.z.toFixed(2)+" w :"+g.w.toFixed(2); 
			
		}
		
		protected function onGyro(event:DeviceEvent):void
		{
			
			//lets apply a filter effect based on the device velocity 
			var g:BMGyro = event.value as BMGyro ;
			//we are shaking!
			if(this.contains(pad))
			{
				dev._device.filters=[new GlowFilter(0xff8800,( g.x+g.y+g.z),g.x*10,g.y*10,( g.x+g.y+g.z)*3)];
			}
			else
			{
				dev._device.filters=[new GlowFilter(0xff0000,( g.x+g.y+g.z),g.x*5,g.y*5,( g.x+g.y+g.z))];
			}			
			
			gText.text="Gyro "+g.x.toFixed(2)+" "+g.y.toFixed(2)+" "+g.z.toFixed(2); 
		}
		
		protected function onShake(event:ShakeEvent):void
		{	
			//add the pad representation to the stage to indicate shake motion.
			trace('onShake');
			addChild(pad);
			pad.alpha=.25;
			flash.utils.setTimeout(checkPad,1000);
		}
		
		private function checkPad():void{
			
			if(contains(pad))
				removeChild(pad);
		}
	}
}