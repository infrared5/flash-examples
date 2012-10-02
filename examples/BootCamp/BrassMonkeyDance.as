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
	public class BrassMonkeyDance extends MovieClip {
		
		public var brassmonkey:BMApplication;
		
		public var graphicPoints:Object={};

		public function BrassMonkeyDance() {
						
			// throw errors.
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
			brassmonkey.initiate("Dance Monkey Dance!",16);


			// Make our control scheme.
			var controlScheme:ControlScheme = new ControlScheme();
			
			//add the contols we made to brass monkey
			brassmonkey.session.registry.validateAndAddControlXML(BMControls.parseMovieClip(controlScheme));
			
			
			//Start the session!
			brassmonkey.start();
			
			
		}
		public function bmPause():void
		{
			
		}
		//button handler
		public function myButton(btn:String):void
		{
			
			//who pressed a button?
			var whoInvoked:Device = BMInvoke.SOURCE;
			
			for(var i:int=0;i<this.numChildren;i++)
			{			
			}
			
		}
		
		private function onDeviceConnected(event:DeviceEvent):void
		{
			
			//prepare a clip and add it
			var clip:DancingDevice=new DancingDevice();
			clip.name=event.device.deviceId;
			clip.x=(200)
			clip.y=(450)
			MovieClip(clip).filters=[new DropShadowFilter(0xffffff)]

			
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
		
		private function onAccel(event:AccelerationEvent):void
		{

			for(var i:int=0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i).name == event.deviceId)
				{
						var monkey:DancingDevice= this.getChildAt(i) as DancingDevice;
						monkey._monkey.rotationY =event.acceleration.y * 45;
					monkey._monkey._torso.rotationZ= event.acceleration.z *25;
					monkey._monkey._head.rotationZ = event.acceleration.z *10 ;
					monkey._monkey._head.rotationZ = event.acceleration.y *3 ;
					monkey._monkey._torso._leftArm.rotationZ =Math.abs(event.acceleration.y * 45);
					monkey._monkey._torso._rightArm._arm.rotationZ=Math.abs(event.acceleration.z * 30);
					monkey._monkey._torso._leftArm._foreArmL.rotationZ=event.acceleration.x * 5;
					return;
				}
			}

		}
		
	}
	
}
