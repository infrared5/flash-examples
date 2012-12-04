package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.SettingsManager;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.BMDisplayObject;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.devices.messages.BMGyro;
	import com.brassmonkey.devices.messages.BMOrientation;
	import com.brassmonkey.discovery.DeviceManager;
	import com.brassmonkey.events.AccelerationEvent;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.ShakeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Orientation3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.Direction;
	import flash.geom.Point;
	

	public class DPad extends Sprite
	{
		public var pad:DPadScheme=new DPadScheme();
		public var lan:BMApplication;
		public var gText:TextField = new TextField();
		public var oText:TextField = new TextField();
		[Embed(source="on.mp3")]
		public var sound:Class;
		[Embed(source="off.mp3")]
		public var sound2:Class;
		private static var avId:int=Math.round(Math.random()*99999+11111);
		
		
		public function DPad()
		{
			display_dpad.stop();
			
			lan=new BMApplication(loaderInfo.parameters);
			lan.initiate("D-Pad Demo",1);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
			
			var scheme:AppScheme=BMControls.parseDynamicMovieClip(pad,false,false,"landscape",480,320,AppDisplayObject.LINEAR);
			
			//remove hit rects from display and apply the hit areas  to the buttons.
			
			var ul:Rectangle=scheme.removeChildByName("hittopleft").rect;
			BMButton(scheme.getChildByName("padUpLeft")).hitRect = ul;
			var u:Rectangle=scheme.removeChildByName("hittop").rect;
			BMButton(scheme.getChildByName("padUp")).hitRect = u;
			var ur:Rectangle=scheme.removeChildByName("hittopright").rect;
			BMButton(scheme.getChildByName("padUpRight")).hitRect = ur;			
			var r:Rectangle=scheme.removeChildByName("hitright").rect;
			BMButton(scheme.getChildByName("padRight")).hitRect = r;
			var dr:Rectangle=scheme.removeChildByName("hitbottemright").rect;
			BMButton(scheme.getChildByName("padDownRight")).hitRect = dr;
			var d:Rectangle=scheme.removeChildByName("hitbottem").rect;
			BMButton(scheme.getChildByName("padDown")).hitRect = d;
			var dl:Rectangle=scheme.removeChildByName("hitbottemleft").rect;
			BMButton(scheme.getChildByName("padDownLeft")).hitRect = dl;
			var l:Rectangle=scheme.removeChildByName("hitleft").rect;
			BMButton(scheme.getChildByName("padLeft")).hitRect = l;
			var ha:Rectangle=scheme.removeChildByName("hita").rect;
			var hb:Rectangle=scheme.removeChildByName("hitb").rect;
			BMButton(scheme.getChildByName("btnA")).hitRect = ha;
			BMButton(scheme.getChildByName("btnB")).hitRect = hb;

			//validate
			lan.session.registry.validateAndAddControlXML(scheme.toString());			
			
			lan.start();
			
			addChild(lan.session.getSlotDisplay());

		}
		
		protected function onDevice(event:DeviceEvent):void
		{
			switch(event.type)
			{
				case DeviceEvent.DEVICE_LOADED:
					event.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
					break;
				
				case DeviceEvent.DEVICE_DISCONNECTED:
					//AvatarManager.anim_walk(avId,"s", true);
					event.device.removeEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
					break;
			}
		}
		
		protected function onButton(event:DeviceEvent):void
		{		
			var dir:String="";

			if(event.value.name=="btnA" || event.value.name=="btnB" )
			{			
				var snd2:Sound =null
				if(event.value.state=="up")
					snd2 = new sound2() as Sound;
				else
					snd2 = new sound() as Sound;
			
				snd2.play(0,0,new SoundTransform(.333));	
				return;
			}
					

			
			
			if(lan.clientButtonStates[event.device.deviceId]['padUp'] == 'down')
			{							
				display_dpad.gotoAndStop(2);
				dir="n";
			}
			if(lan.clientButtonStates[event.device.deviceId]['padRight'] == 'down')
			{								
				display_dpad.gotoAndStop(5);
				dir="e";
			}		
			if(lan.clientButtonStates[event.device.deviceId]['padDown'] == 'down')
			{			
				display_dpad.gotoAndStop(3);
				dir="s";
			}
			if(lan.clientButtonStates[event.device.deviceId]['padLeft'] == 'down')
			{							
				display_dpad.gotoAndStop(4);
				dir="w";
			}


			if(lan.clientButtonStates[event.device.deviceId]['padUpRight'] == 'down')
			{								
				display_dpad.gotoAndStop(6);
				dir="ne";
			}			
			if(lan.clientButtonStates[event.device.deviceId]['padDownRight'] == 'down')
			{								
				display_dpad.gotoAndStop(9);
				dir="se";
			}	
			if(lan.clientButtonStates[event.device.deviceId]['padDownLeft'] == 'down')
			{			
				display_dpad.gotoAndStop(8);
				dir="sw";
			}	
			if(lan.clientButtonStates[event.device.deviceId]['padUpLeft'] == 'down')
			{					
				display_dpad.gotoAndStop(7);
				dir="nw";
			}
			

			
			else if(event.value.state=="up" && dir=="")
			{				
				switch(event.value.name)
				{
					case "padDownLeft":
						display_dpad.gotoAndStop(1);
						break;
					case "padDown":
						display_dpad.gotoAndStop(1);
						break;
					case "padUp":
						display_dpad.gotoAndStop(1);
						break;
					case "padUpRight":
						display_dpad.gotoAndStop(1);
						break;
					case "padDownRight":
						display_dpad.gotoAndStop(1);
						break;
					case "padLeft":
						display_dpad.gotoAndStop(1);
						break;
					case "padUpLeft":
						display_dpad.gotoAndStop(1);
						break;
					case "padRight":
						display_dpad.gotoAndStop(1);
						break;
				}
			}	
		}
	}
}