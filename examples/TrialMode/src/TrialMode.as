package
{
	import com.adobe.images.PNGEncoder;
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppDisplayObjectAssetReference;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.controls.writer.OutputData;
	import com.brassmonkey.events.DeviceEvent;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * This demo shows how to listen for trial-mode events so that your application 
	 * can be aware of which devices have paid for premium content. 
	 * Developers who sign up for an account can configure their games as premium content 
	 * with prices per session-and 'buy forever' options.
	 * 
	 * @author Andy Shaules
	 * 
	 */	
	public class TrialMode extends Sprite
	{
		private var lan:BMApplication;
		
		private var controlDesign:AppScheme;
		
		private var renderer:DeviceInfo=new DeviceInfo();
		
		public function TrialMode()
		{
			//Create a app interface using possible loader hooks.
			lan=new BMApplication(loaderInfo.parameters);
			//initiate the interface with the specific app id you have configured.
			lan.initiate("Trial Mode Test",1,"bcb5378fa6118f37995aaa2081e094d7");
			// Listen for device loaded/ready to add button handler.
			lan.addEventListener(DeviceEvent.DEVICE_AVAILABLE , onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			// Listen for the initial moment that the trial-mode is known.
			lan.addEventListener(DeviceEvent.TRIAL_MODE, onTrialMode);
			//lan.addEventListener(DeviceEvent.SLOT_DISPLAY_REQUEST, onSlot);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDisconnected);
			
			//Create a scheme on the fly.
			//create a control design skeleton with a blank movie clip/
			controlDesign= BMControls.parseDynamicMovieClip(new MovieClip(),false,true,"portrait",320,480,"nearest");
			//create a background.
			createBackground();
			//create a button
			createButton();
			
			
			//validate the design image assets
			lan.session.registry.validateAndAddControlXML(controlDesign.toString());
			//start the lan app session.			
			lan.start();
			
			//add the information feedback gui.
			addChild(renderer);
			renderer.x=10;
			renderer.y=10;
			renderer.deviceName.text="Connect";
			renderer.trialMode.text="Trial mode status";
			
		}

		
		protected function onTrialMode(event:DeviceEvent):void
		{
			
			trace("Trial mode check for "+ event.device.deviceName+" . Should we treat this game as trial-mode? "+event.device.trialMode);
			//If the user account has paid for a session, or paid for the application, the 'event.device.trialMode' will be false. This value can be read anytime hereafter.
			//If the user has not opted to pay, but you allow trial-mode session, the value will be 'true' and you can restrict levels, 
			// or access to premium content.
			renderer.deviceName.text=event.device.deviceName;
			renderer.trialMode.text = "Device Trial-Mode is "+ ((event.device.trialMode===true)?"on":"off");
		}
		/**
		 * Add a handler to listen for button events. 
		 * @param event
		 * 
		 */		
		protected function onDevice(event:DeviceEvent):void
		{			
			event.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
		}
		protected function onDisconnected(event:DeviceEvent):void
		{
			event.device.removeEventListener(DeviceEvent.SCHEME_BUTTON, onButton);
			renderer.deviceName.text="Connect";
			renderer.trialMode.text="Trial mode status";
			
		}
		/**
		 * Button event captures are in the 'event.value' object, 
		 * and all button states are cached in the 'lan.clientButtonStates' object, 
		 * indexed by 'device.deviceId'. 
		 * @param event
		 * 
		 */		
		protected function onButton(event:DeviceEvent):void
		{
			trace(event.value.name,event.value.state);
			
		}
		/**
		 * Create a simple black background into the skeleton design scheme. 
		 * 
		 */		
		public function createBackground():void
		{				
			
			var ado:AppDisplayObject=new AppDisplayObject();
			ado.type="image";
			ado.clazz="custom";			
			ado.functionHandler="up";
			ado.hidden=false;
			ado.name="background";
			ado.page=1;
			ado.rect=new Rectangle(0,0,320,480);
			
			ado.sample=AppDisplayObject.NEAREST;
			
			var functionHandler:String = "up"
				
			var bitmapData:BitmapData=new BitmapData(320,480,true,0xFF000000);
					
			var bdU:ByteArray = PNGEncoder.encode(bitmapData);
			
			var riD:int=AppScheme.getUniqueId();
			
			var adoa:AppDisplayObjectAssetReference=new AppDisplayObjectAssetReference("up",riD);			
			
			ado.assetReferences.push(adoa);			
		
			controlDesign.layout.displayObjects.push(ado);
			
			var outU:OutputData=new OutputData(riD,Base64.encode(bdU),"image");	
			
			controlDesign.resources.resources.push(outU);

		}
		/**
		 * Create a simple button 
		 * 
		 */		
		public function createButton():void
		{				
			//construct a generic control scheme display object.
			var ado:AppDisplayObject=new AppDisplayObject();
			//It will be a button.
			ado.type="button";
			//usually this is the qualified class name of the display object, 
			//but we are are making one on the fly so it does not matter what we put. 
			ado.clazz="custom";
			//the scriptable button name that the triggers will use.
			ado.functionHandler="btnTest";			
			//app scheme control object reference name that can be used to re-reference this same object again.
			//Using controlDesign.getChildByName("btnTest"), we could potentially change or add objects;
			ado.name="btnTest";
			//we do display this object by defualt.
			ado.page=1;//not hidden by defualt.
			ado.hidden=false;
			//the location this button occupies, where (0,0,1,1) equals the entire screen.
			ado.rect=new Rectangle(.2,.2,.4,.4);//(left * width),(top * height),(extendsTo * width),(extendsTo * height); 
			//scale mode used to resize object on different screens.
			ado.sample=AppDisplayObject.NEAREST;//nearest-neighbor sampling vs Bi-Linear.
			
		
			//button graphics up state.
			var bitmapData:BitmapData=new BitmapData(150,150,true,0xFFccFFcc);
			//encode it to portable network gfx.
			var bdU:ByteArray = PNGEncoder.encode(bitmapData);
			//create a reference to it.
			var riDUp:int=AppScheme.getUniqueId();			
			var adoa:AppDisplayObjectAssetReference=new AppDisplayObjectAssetReference("up",riDUp);				
			ado.assetReferences.push(adoa);	
			//gather the gfx serialized data, and encode it for safe transport.
			var outU:OutputData=new OutputData(riDUp,Base64.encode(bdU),"image");			
			controlDesign.resources.resources.push(outU);
			
			
			//repeat for button graphics down state.
			var bitmapDataDown:BitmapData=new BitmapData(150,150,true,0xFFFF0000);
			//encode it to portable network gfx.
			var bdD:ByteArray = PNGEncoder.encode(bitmapDataDown);
			//create a reference to it.
			var riDDown:int=AppScheme.getUniqueId();			
			var adoaDown:AppDisplayObjectAssetReference=new AppDisplayObjectAssetReference("down",riDDown);				
			ado.assetReferences.push(adoaDown);			
			//gather the gfx serialized data, and encode it for safe transport.
			var outD:OutputData=new OutputData(riDDown,Base64.encode(bdD),"image");
			controlDesign.resources.resources.push(outD);
			
			
			//finally add our button control display object to the application control design.
			controlDesign.layout.displayObjects.push(ado);
			
			
		}
		
	}
}