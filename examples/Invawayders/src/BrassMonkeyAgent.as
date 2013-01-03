package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.events.AccelerationEvent;
	import com.brassmonkey.events.DeviceEvent;
	
	import flash.display.MovieClip;
	import com.brassmonkey.devices.messages.BMOrientation;
	import com.brassmonkey.devices.Device;

	public class BrassMonkeyAgent
	{
		
		private var _game:IGameInterface;
		private var lan:BMApplication;
		
		private var controlClip:InvaderControls=new InvaderControls();
		private var scheme:AppScheme;
		private var _isPaused:Boolean = false;
		private var _isReplay:Boolean = false;

		
		
		public function BrassMonkeyAgent(owner:IGameInterface)
		{
			_game=owner;
		}
		public function startAgent(params:Object):void
		{
			lan=new BMApplication(params);
			lan.initiate("Invawayders",1);
		 	scheme=BMControls.parseDynamicMovieClip(controlClip,true,false);
			lan.session.registry.validateAndAddControlXML(scheme.toString());
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
			
			
			lan.start();
		}
		
		protected function onDevice(event:DeviceEvent):void
		{
			switch(event.type)
			{
				case DeviceEvent.DEVICE_LOADED:
					event.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
					//if(!event.device.capabilities.hasOrientation)
					//{
						event.device.addEventListener(AccelerationEvent.ACCELERATION, onAccel);
						lan.session.enableAccelerometer(event.device,true,1/24);
					//}
					//else
					//{
					//	event.device.addEventListener(DeviceEvent.ORIENTATION, onOrientation);
					//	lan.session.enableOrientation(event.device,true);
					//	lan.session.setOrientationInterval(event.device,1/30);
					//}

					break;
				
				case DeviceEvent.DEVICE_DISCONNECTED:
					event.device.removeEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
					event.device.removeEventListener(DeviceEvent.ORIENTATION, onOrientation);
					event.device.removeEventListener(AccelerationEvent.ACCELERATION, onAccel);
					break;
				
			}		
		}
		
		protected function onOrientation(event:DeviceEvent):void
		{
			var g:BMOrientation = event.value as BMOrientation ;
			_game.brassMonkeyMoveInput(-g.x*1.5 , (g.y*1.5) );	
			
		}
		
		protected function onAccel(event:AccelerationEvent):void
		{
			_game.brassMonkeyMoveInput(event.acceleration.y,event.acceleration.x);
			
		}
		
		protected function onButton(event:DeviceEvent):void
		{
			switch(event.value.name)
			{
				case "fire1":
				case "fire2":
					
					_game.clientfire(lan.clientButtonStates[event.device.deviceId].fire1 == "down"
						|| lan.clientButtonStates[event.device.deviceId].fire2 == "down");
					
					break;
				
				case "start":
					if(_isReplay)
					{
						lan.session.updateControlScheme(event.device, scheme.pageToString(2));
						_game.brassMonkeyRestart();
					}
					else
					{
						lan.session.updateControlScheme(event.device, scheme.pageToString(2));
						_game.brassMonkeyStart();
					}
					break;
				case "pauseGame":
					if(event.value.state=="down")
						return;
					
					if(!_isPaused)
						_game.brassMonkeyPause();
					else
						_game.brassMonkeyResume();
					
					_isPaused=!_isPaused;
					
					break;
				
						
			}
			
		}
		
		public function gameOver():void
		{
			var device:Device = lan.session.registry.getDevice(null);
			_isReplay=true;
			if(device!=null)
				lan.session.updateControlScheme(device, scheme.pageToString(1));
		}
		
		public function stopAgent():void
		{
			lan.session.stop();
		}
	}
}