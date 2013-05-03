package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.SettingsManager;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMDPad;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.controls.writer.StageScaler;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.externals.DPadUpdate;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	[SWF(width="800", height="600", backgroundColor="000000")]
	public class DPad extends Sprite
	{
		//public var pad:DPadScheme=new DPadScheme();
		public var lan:BMApplication;

		public var display_dpad:DisplayDPad=new DisplayDPad();
				
		private var scheme:AppScheme;
		private var direction:Point=new Point();
		public var _feedback:TextFeedback=new TextFeedback();

		public function DPad()
		{
			_feedback.x=128;
			_feedback.y=500;			
			display_dpad.stop();
			addChild(display_dpad);
			addChild(_feedback);
			display_dpad.x=400;
			display_dpad.y=300;
			//we require new brass monkey dpad feature.
			//set minimum version 1.7.0
			SettingsManager.VERSION_MINIMUM.major=1;			
			SettingsManager.VERSION_MINIMUM.minor=7;
			
			lan=new BMApplication(loaderInfo.parameters);
			lan.initiate("D-Pad Demo",1);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
			
			//setting up a scheme manually for screen resolution 480 x 320 
			StageScaler.LONG=480;
			StageScaler.SHORT=320;
			StageScaler.SetLandscape();
			//creating a control scheme for the above screen resolution.
			scheme=new AppScheme(480,320,"landscape",false,false,"linear");
			//setup rectangles for componentes.
			var backgroundRect:Rectangle=new Rectangle(0,0,480,320);
			var dpadTouchRect:Rectangle=new Rectangle(12,20,252,282);
			var dpadVisableRect:Rectangle=new Rectangle(44,75,180,180);
			var buttonATouch:Rectangle=new Rectangle(301,174,75,104);
			var buttonADisplay:Rectangle=new Rectangle(260,143,151,151);
			var buttonBTouch:Rectangle=new Rectangle(383,88,75,104);
			var buttonBDisplay:Rectangle=new Rectangle(342,65,151,151);

			//create a background with premade movie clip.
			var bg:BMImage=new BMImage(StageScaler.ScaleFlashRect(backgroundRect,true),new Background());
			bg.name="background";
			//The page variable helps with automating view stacks 
			//using scheme.pageToString(i) with a dynamic control updates.
			//We want these to all be on the defualt top view, page 1.
			bg.page=1;			
			scheme.addChild(bg);
			
			//create a pais of A/B buttons.			
			var btnA:BMButton = new BMButton(StageScaler.ScaleFlashRect(buttonADisplay,false),new ButtonTest(),new ButtonTestDown(),"btnA");
			btnA.page=1;
			btnA.hitRect=StageScaler.ScaleFlashRect(buttonATouch,false);
			scheme.addChild(btnA);

			var btnB:BMButton = new BMButton(StageScaler.ScaleFlashRect(buttonBDisplay,false),new ButtonTest2(),new ButtonTest2Down(),"btnB");
			btnB.page=1;
			btnB.hitRect=StageScaler.ScaleFlashRect(buttonBTouch,false);
			scheme.addChild(btnB);
			
			//create a dpad.
			var dpd:BMDPad= new BMDPad();
			//set scheme frame/page. 
			dpd.page=1;
			//apply rects.
			dpd.hitRect=StageScaler.ScaleFlashRect(dpadTouchRect,false);
			dpd.rect=StageScaler.ScaleFlashRect(dpadVisableRect,false);			
			//alter the size of the dead zone.
			dpd.deadZone=30;
			//use radial or box mode.
			dpd.radial=true;
			//draw movieclips and set bitmap data for the dpad states.
			//inactive/up-state			
			dpd.inactive =  dpd.draw( new PadImage()); 
			//direction down, downsatate.
			dpd.down = dpd.draw(new PadBtnDnDown());
			//direction left, downsatate.
			dpd.left = dpd.draw(new PadBtnLtDown());
			//direction leftDown, downsatate.
			dpd.leftDown = dpd.draw(new PadBtnDnLtDown());
			//direction leftUp, downsatate.
			dpd.leftUp = dpd.draw(new PadBtnUpLtDown());
			//direction right, downsatate.
			dpd.right = dpd.draw(new PadBtnRtDown());
			//direction rightDown, downsatate.
			dpd.rightDown= dpd.draw( new PadBtnDnRtDown());
			//direction rightUp, downsatate.
			dpd.rightUp = dpd.draw(new PadBtnUpRtDown());
			//direction up, downsatate.
			dpd.up = dpd.draw(new PadBtnUpDown());					
			//add to scheme.
			scheme.addChild(dpd);
			
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
					//listen for dpad data.
					event.device.addEventListener(DeviceEvent.DPAD, onDPad);				
					
					break;
				
				case DeviceEvent.DEVICE_DISCONNECTED:					
					event.device.removeEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
					event.device.removeEventListener(DeviceEvent.DPAD, onDPad);
					break;
			}
		}
		
		protected function onDPad(event:DeviceEvent):void
		{
			var update:DPadUpdate=event.value as DPadUpdate; 	
			//get current dpad direction intent.
			direction.x=update.x;
			direction.y=update.y;			
			process();
		}
		
		
		protected function onButton(event:DeviceEvent):void
		{		
			
			if(event.value.name=="btnA"  )
			{			
				return;	
			}
			else if(event.value.name=="btnB")
			{
				return;
			}
			
		}
		
		public function process():void
		{
			
			var dir:String="";
			
			if(direction.y<0 )
			{											
				dir="n";
			}
			else if(direction.y>0 )
			{							
				dir="s";
			}
			
			if(direction.x>0 )
			{												
				dir+="e";
			}
			else if(direction.x<0)
			{				
				dir+="w";
			}
			
			
			switch(dir)
			{
				case "n":
					display_dpad.gotoAndStop(2);
					break;
				case "s":
					display_dpad.gotoAndStop(3);
					break;
				case "e":
					display_dpad.gotoAndStop(5);
					break;
				case "w":
					display_dpad.gotoAndStop(4);
					break;
				case "ne":
					display_dpad.gotoAndStop(6);
					break;
				case "nw":
					display_dpad.gotoAndStop(7);
					break;
				case "se":
					display_dpad.gotoAndStop(9);
					break;
				case "sw":
					display_dpad.gotoAndStop(8);
					break;	
				default:
					display_dpad.gotoAndStop(1);
					break;
				
			}
		}		
	}
}