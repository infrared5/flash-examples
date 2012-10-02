package  {
	
	import flash.display.MovieClip;
	
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.SettingsManager;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.events.AccelerationEvent;
	import com.brassmonkey.devices.messages.Acceleration;
	import com.brassmonkey.externals.BMInvoke;
	import com.brassmonkey.devices.Device;
	
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.filters.DropShadowFilter;


	
	/** 
	 *
	 *	Draw lines via acceleration.
	 *  @author Andy Shaules
	 */
	public class BrassMonkeyFlash extends MovieClip {
		
		public var brassmonkey:BMApplication;
		
		public var graphicPoints:Object={};

		public function BrassMonkeyFlash() {
						
			// throw errors and add additional trace out.
			SettingsManager.DEBUG=true;
			
			//Make an app. Always pass the loaderinfo parameters to the constructor. 
			//It may contian the hooks the portal uses to transfer players to your game.
			brassmonkey=new BMApplication(loaderInfo.parameters);
			brassmonkey.addEventListener(DeviceEvent.DEVICE_CONNECTED, onDeviceConnected);
			brassmonkey.addEventListener(DeviceEvent.DEVICE_LOADED, onDeviceReady);
			brassmonkey.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDeviceDisconnected);
			brassmonkey.addEventListener(AccelerationEvent.ACCELERATION, onAccel);
			//set the client
			brassmonkey.client=this;
			//Initiate. Then setup controls.
			brassmonkey.initiate("BrassMonkey Flash",4);
			

			// Make our control scheme.
			var controlScheme:ControlScheme = new ControlScheme();
			
			//add the contols we made to brass monkey
			brassmonkey.session.registry.validateAndAddControlXML(BMControls.parseMovieClip(controlScheme));
			
			
			//Start the session!
			brassmonkey.start();
			
			
		}
		
		//button handler
		public function myButton(btn:String):void
		{
			
			//who pressed a button?
			var whoInvoked:Device = BMInvoke.SOURCE;
			
			for(var i:int=0;i<this.numChildren;i++)
			{			
					if(whoInvoked.deviceId==getChildAt(i).name)
						DeviceSprite(getChildAt(i)).graphics.lineStyle(1,(( Math.random()*255 &0xff) <<16 |  (Math.random()*255 &0xff) <<8 | ( Math.random()*255 &0xff))) ;
			}
			
		}
		
		private function onDeviceConnected(event:DeviceEvent):void
		{
			
			//prepare a clip and add it
			var clip:DeviceSprite= new DeviceSprite();
			clip.x=(200)
			clip.y=(250)
			MovieClip(clip).filters=[new DropShadowFilter(0xffffff)]
			
			clip.name=event.device.deviceId;
			clip.graphics.lineStyle(1);
			
			graphicPoints[event.device.deviceId]=new Point();
			
			addChild(clip);
			
		}
		
		private function onDeviceReady(event:DeviceEvent):void
		{
			//device is loaded.
			trace(event.device.deviceId)
		}
		
		private function onDeviceDisconnected(event:DeviceEvent):void
		{
			//remove the clip
			
			for(var i:int=0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i).name == event.device.deviceId)
				{
					this.removeChildAt(i);
					return;
				}
			}
			
			
			trace(event.device.deviceId)
		}		
		public function bmPause():void
		{
			
		}
		private function onAccel(event:AccelerationEvent):void
		{

			for(var i:int=0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i).name == event.deviceId)
				{
					var current:Point = graphicPoints[event.deviceId];
					current.x+=event.acceleration.x*2;
					current.y+=event.acceleration.y*2;
					trace(current);
					MovieClip(this.getChildAt(i)).rotation+=event.acceleration.z*1

					MovieClip(this.getChildAt(i)).graphics.lineTo(current.x,current.y);
					
					MovieClip(this.getChildAt(i)).graphics.endFill();
					return;
				}
			}

		}
		
	}
	
}
