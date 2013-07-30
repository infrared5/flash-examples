package
{
	import com.adobe.images.PNGEncoder;
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppDisplayObjectAssetReference;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.AppSchemeHeader;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMDPad;
	import com.brassmonkey.controls.writer.BMDynamicText;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.controls.writer.OutputData;
	import com.brassmonkey.controls.writer.StageScaler;
	import com.brassmonkey.events.DeviceEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ScreenSizes extends Sprite
	{
		private var lan:BMApplication;
		
		
		
		private var defaultScheme:AppScheme;//0
		private var gTabScheme:AppScheme;//1
		private var ipad2:AppScheme;//2
		
		private var menuScheme:AppScheme;//Aux
		
		//what page is the unique dpad going to be on?
		//If you change this, change the button logic in the button handler.
		//our demo places the custom dpad on page 2.
		private static var DPAD_PAGE:int = 2;
		
		//We are going to take the Menu scheme, and append it to each other scheme to create 3 schems in total.
		
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
			defaultScheme=BMControls.parseDynamicMovieClip(new DefaultScreen(),false,true,"landscape",480,320,AppDisplayObject.LINEAR);
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
			//lan.session.registry.validateAndAddControlXML(defaultScheme.toString());			

			// Samsung GT-P3113 or equivalent.
			
			//set the screen pixel size
			StageScaler.LONG=976;
			StageScaler.SHORT=600;
			// clear graphics registry. This insures that this new XML is not referencing the resources on the other XML.
			AppScheme.clearRegistry();
			
			gTabScheme=BMControls.parseDynamicMovieClip(new GalaxyScreen(),false,true,"landscape",976,600,AppDisplayObject.LINEAR);
			//remove dpad rectangle place holder movie clip and get the rect.
			rect=gTabScheme.removeChildByName("dpad").rect;
			dpd.hitRect=rect;
			dpd.rect=rect;			
			//alter the % of the middle dead zone between 0 and 1.
			dpd.deadZone=.25;
			gTabScheme.addChild(dpd);			
			
			//lan.session.registry.validateAndAddControlXML(gTabScheme.toString());			
			
			
			
			//set the screen pixel size
			StageScaler.LONG=1024;
			StageScaler.SHORT=768;
			// clear graphics registry. This insures that this new XML is not referencing the resources on the other XML.
			AppScheme.clearRegistry();
			
			//We use the BMControls factory to parse all the chidren of that movie clip, preparing the image data for export.
			ipad2=BMControls.parseDynamicMovieClip(new IOSScreen(),false,true,"landscape",1024,768,AppDisplayObject.LINEAR);
			
			rect =ipad2.removeChildByName("dpad").rect;

			//set scheme frame/page. 
			dpd.page=1;
			//apply rects.
			dpd.hitRect=rect;
			dpd.rect=rect;			
			//alter the % of the middle dead zone between 0 and 1.
			dpd.deadZone=.25;
			ipad2.addChild(dpd);
			
		
			
			
			//Choosing dpad Page as ONE.
			//All others are Menu and need letterboxing.
			//Menu has 3 or more pages.
			
			//Ok. Here is were it gets tricky. 
			//We have just made three independant dpads with the same number of resources.
			
			//Things to consider:
			// - how manu menu pages?
			// - What page/view do you want the dpad on?
			// - EDGE CASE: If each unique DPAD view does not contain the same EXACT number of assets, such as having more or less buttons, 
			//		the view with the MOST stuff/resources shoulde be parsed LAST, but PRIOR to parsing the MENU.
			//		This is so that asset ids in the menu progess monotonically from the highest value in the richest control set.

			AppScheme.clearRegistry();
			StageScaler.LONG=480;			
			StageScaler.SHORT=320;
			
			menuScheme = BMControls.parseDynamicMovieClip(new MenuScreens(),false,true,"landscape",480,320,AppDisplayObject.LINEAR);
			
			//any page but DPAD page for letterbox.
			//letter box color will cover dpad if it is the same.
			//see note inside 'onButton' about letter box.
			addLetterboxing(defaultScheme, (DPAD_PAGE==1?2:1));				
			add(menuScheme,defaultScheme,DPAD_PAGE);
			
			addLetterboxing(gTabScheme, (DPAD_PAGE==1?2:1));			
			add(menuScheme,gTabScheme,DPAD_PAGE);
			
			addLetterboxing(ipad2, (DPAD_PAGE==1?2:1));			
			add(menuScheme,ipad2,DPAD_PAGE);			
			
			
			//Finally add them!
			lan.session.registry.validateAndAddControlXML(defaultScheme.toString());	
			lan.session.registry.validateAndAddControlXML(gTabScheme.toString());	
			lan.session.registry.validateAndAddControlXML(ipad2.toString());
			
			lan.start();
		
		}
		/**
		 * Assumption is that your source menu will always smaller or equal to the destination parent.  
		 * @param fromThis
		 * @param toThis
		 * 
		 */		
		private function add(fromThis:AppScheme, toThis:AppScheme, dpadPageIs:int):void
		{
			//set dpad to desired page first.
			for each(var adoPage:AppDisplayObject in toThis.layout.displayObjects)
			{
				if(adoPage.name=="letterbox")
					continue;
				
				adoPage.page=dpadPageIs;
			}
			
			var sX:Number = parseInt(fromThis.header.width);
			var sY:Number = parseInt(fromThis.header.height);
			var dX:Number = parseInt(toThis.header.width);
			var dY:Number = parseInt( toThis.header.height);
					
			var differenceX:Number = dX-sX;			
			var differenceY:Number = dY-sY;			
			
			var factorX:Number = (sX + differenceX) /sX;			
			var factorY:Number = (sY + differenceY) /sY;

			//imagine we have 100 pixels more in width;
			//Divide the diference in half.
			var letterBoxStripX:Number = differenceX/2;
			var letterBoxStripY:Number = differenceY/2;
			//scale this to a float against the destination.
			// the full screen size of the largest delta was..

			//Do the scale to floats for 'theMeasurementBigDestination' delta.
			//Now we have the float value that equals the letter box measurement from left or top.
			letterBoxStripX=letterBoxStripX/dX;
			letterBoxStripY=letterBoxStripY/dY;
			
			for each(var resourceData1:OutputData in fromThis.resources.resources)
			{					
				// we need this one in the new scheme.
				// assuming that the lowest ID of the menu is higher than highest in the destination.
				// add to the destination
				toThis.resources.resources.push(resourceData1);	
				resourceData1.hasUpdated=true;
			}
			for each(var resourceData:OutputData in toThis.resources.resources)
			{	
				resourceData.hasUpdated=true;
			}
			
			//we need to bump stuff over/down	including page. 		
			for(var i:int=0;i<fromThis.layout.displayObjects.length; i++)
			{				
				var disp:AppDisplayObject = fromThis.layout.displayObjects[i];
				var originalArtwork:Rectangle = scaleFloatsToInts(disp,fromThis.header);
				

				
				var originalArtAsNewfloats:Rectangle = scaleIntsToFloats(originalArtwork, dX,dY); 
				
				
				
				originalArtAsNewfloats.x += letterBoxStripX;
				
				originalArtAsNewfloats.y += letterBoxStripY;
				
				trace('originalArtAsNewfloats',originalArtAsNewfloats.x, originalArtAsNewfloats.y, originalArtAsNewfloats.width,originalArtAsNewfloats.height);

				var ndsp:AppDisplayObject;
				if(disp.type=='image')
				{
					ndsp= new BMImage(originalArtAsNewfloats,null);
					
				}
				if(disp.type=='button')
				{
					ndsp = new BMButton(originalArtAsNewfloats,null,null,disp.functionHandler);
					
					ndsp.functionHandler=disp.functionHandler;
					
				}				

				if(disp.type=='text')
				{
					ndsp = new BMDynamicText(originalArtAsNewfloats,null,0);
					var bmOrig:BMDynamicText = disp as BMDynamicText;
					var bmcopy:BMDynamicText = ndsp as BMDynamicText;
					var originalText:Number = sY*bmOrig.textSize;
					bmcopy.textSize = originalText/dY;
					bmcopy.color = bmOrig.color;
					bmcopy.text = bmOrig.text;
					
				}
				if(!ndsp)
					continue;
				
				
				if(disp.hasOwnProperty("hitRect") && disp["hitRect"]!=null) 
				{
					var hrRect:Rectangle = disp["hitRect"];
					var originalHitrectAsNewfloats:Rectangle = scaleHitrectToInts(hrRect,fromThis.header);
					ndsp["hitRect"]=originalHitrectAsNewfloats;
				}
				
				
				
				ndsp.hidden=disp.hidden;
				ndsp.id=disp.id;
				ndsp.name=disp.name;
				ndsp.sample=disp.sample;
				ndsp.type=disp.type;
				ndsp.assetReferences=disp.assetReferences;				
				ndsp.page =  disp.page>=dpadPageIs? ( disp.page + 1): disp.page ;
			
				
				toThis.layout.displayObjects.push(ndsp);
				
				
				//are we done?				
				//Maybe... 
				//Note that letterbox page needs to be changed for every menu view. 
			}
			
			
	
		}
		
		private function addLetterboxing( toThis:AppScheme, onPage:int):void
		{
			var ado:AppDisplayObject=new AppDisplayObject();
			ado.type="image";
			ado.clazz="custom";			
			ado.functionHandler="up";
			ado.hidden=false;
			ado.name="letterbox";
			ado.page=onPage;
			var dX:Number = parseInt(toThis.header.width);
			var dY:Number = parseInt( toThis.header.height);
			ado.rect=new Rectangle(0,0,1,1);
			
			ado.sample=AppDisplayObject.NEAREST;
			
			var functionHandler:String = "up"

			var bitmapData:BitmapData=new BitmapData(16,16,false,0x00000000);
			
			var bdU:ByteArray = PNGEncoder.encode(bitmapData);
			
			var riD:int = 1000;//needs unique per scheme
			
			var adoa:AppDisplayObjectAssetReference=new AppDisplayObjectAssetReference("up",riD);			
			
			ado.assetReferences.push(adoa);			
			
			toThis.layout.displayObjects.push(ado);
			
			var outU:OutputData=new OutputData(riD,Base64.encode(bdU),"image");	
			
			toThis.resources.resources.push(outU);
		}
		
		
		public  function scaleIntsToFloats(rect:Rectangle, w:int,h:int):Rectangle
		{
			var left:Number = rect.x / w;
			var top:Number = rect.y / h;
			var right:Number = rect.width / w;
			var bottom:Number = rect.height / h;
			
			var rect:Rectangle=new Rectangle(left,top,right,bottom); 
			
			return rect;
		}

		private function scaleFloatsToInts(dispObj:AppDisplayObject, from:AppSchemeHeader):Rectangle
		{
			
			var ret:Rectangle = new Rectangle();
			ret.x=dispObj.rect.x*parseInt(from.width);
			ret.width=dispObj.rect.width*parseInt(from.width);
			ret.y=dispObj.rect.y*parseInt(from.height);
			ret.height= dispObj.rect.height*parseInt(from.height);			
			return ret;
			
		}
		private function scaleHitrectToInts(rect:Rectangle, from:AppSchemeHeader):Rectangle
		{
			
			var ret:Rectangle = new Rectangle();
			ret.x=rect.x*parseInt(from.width);
			ret.width=rect.width*parseInt(from.width);
			ret.y=rect.y*parseInt(from.height);
			ret.height= rect.height*parseInt(from.height);			
			return ret;
			
		}		
		protected function onConnected(event:DeviceEvent):void
		{
			event.device.removeEventListener(DeviceEvent.DEVICE_CONNECTED, onConnected);
			event.device.addEventListener(DeviceEvent.CAPABILITIES, onCapabilities);
			
		}
		/**
		 *  device controlSchemeIndex will be set and constant in our case. 
		 * @param event
		 * 
		 */		
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
			event.device.addEventListener(DeviceEvent.SCHEME_BUTTON , onButton);
			
			
		}
		
		protected function onButton(event:DeviceEvent):void
		{
			trace(event.value.name,event.value.state);
			if(event.value.state=="up")
			{			
				
				//OK HERE is the tricky part.
				//We must set the letter box page to the  desired non-dpad page.
				var aps:AppScheme;
				if(event.value.name=="button")//Button on DPAD To go to Menu
				{	//get expanded app scheme.
					aps =  getControls(event.device.controlSchemeIndex);
					//place letter box under view.
					aps.getChildByName("letterbox").page=3;
					lan.session.updateControlScheme(event.device,aps.pageToString(3));
				}
				if(event.value.name=="menuButton1")//MENU on PAGE 1
				{	//get expanded app scheme.
					aps =  getControls(event.device.controlSchemeIndex);
					//place letter box under view.
					//aps.getChildByName("letterbox").page=2;
					lan.session.updateControlScheme(event.device,aps.pageToString(2));
				}
				if(event.value.name=="menuButton2")//MENU on PAGE 2
				{	//get expanded app scheme.
					aps = getControls(event.device.controlSchemeIndex);
					//place letter box under view.
					aps.getChildByName("letterbox").page=4;
					lan.session.updateControlScheme(event.device,aps.pageToString(4));
				}
				if(event.value.name=="menuButton3")//MENU on PAGE 3
				{	//get expanded app scheme.
					aps = getControls(event.device.controlSchemeIndex);
					//no letter box over dpad!
					aps.getChildByName("letterbox").page=1;
					lan.session.updateControlScheme(event.device,aps.pageToString(1));
				}
			}
		}
		
		private function getControls(forThis:int):AppScheme
		{
			switch(forThis)
			{
				case 2:
					return ipad2;
				case 1:
					return gTabScheme;
				default:
					return defaultScheme;
			}
		}

	}
}