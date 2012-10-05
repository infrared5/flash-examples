package
{
	import cards.PokerControlScheme;
	
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.apps.CardModel;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppDisplayObject;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMButton;
	import com.brassmonkey.controls.writer.BMImage;
	import com.brassmonkey.devices.messages.Touch;
	import com.brassmonkey.devices.messages.TouchPhase;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.events.TouchEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="480", height="320")]
	public class Cards extends Sprite
	{
		public var deck:CardModel = new CardModel();
		
		public var bm:BMApplication;
		//public var cursor:Reticle=new Reticle;
		public var appScheme:AppScheme;
		private var pokerCards:PokerControlScheme;
		
		public function Cards()
		{
			addChild(new PokerControlScheme());
		//	addChild(cursor);
			stage.frameRate=60;
			
			//initiate brassmonkey
			bm= new BMApplication(loaderInfo.parameters);
			bm.initiate("Cards", 4);
			//We want to add additional hanlders for touch and button events.
			bm.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			
			
			// A simple scheme to be held in landscape mode.
			pokerCards=new PokerControlScheme();
			
			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(pokerCards,false,false,'landscape',480,320, AppDisplayObject.NEAREST);

			// Add controls to the brassmonkey session.
			bm.session.registry.validateAndAddControlXML(appScheme.toString());
			// GO!
			bm.start();
			
			bm.session.getSlotDisplay().x=10;
			bm.session.getSlotDisplay().y=10;
			//add the slot color.
			addChild(bm.session.getSlotDisplay());
		}

		
		public function onLoaded(de:DeviceEvent):void
		{
			//subscibe to touch events.		
			de.device.addEventListener(DeviceEvent.SCHEME_BUTTON, onButtonPress);

			
		}
		
		protected function onButtonPress(event:DeviceEvent):void
		{
			trace(event.value.name,event.value.state)
			
			if(event.value.state=='up')
				return;
			//get a random number.
			var newCard:int = deck.getCard();
			
			//get the bitmap data
			var bitmap:BitmapData = deck.deck[newCard];
			if(bitmap==null)
				return;
			
			//replace the image.
			
			switch(event.value.name)
			{
				case "tap1":
					//card 1
					while(pokerCards._card1._frame.numChildren)
						pokerCards._card1._frame.removeChildAt(0);
					//add new card to poker hand.
					pokerCards._card1._frame.addChild(new Bitmap(bitmap));
					//draw poker card
					var bd:BitmapData=new BitmapData(pokerCards._card1.width,pokerCards._card1.height,true,0x0);
					bd.draw(pokerCards._card1);
					// After calling 'updateImageData' do not call the 'pageToString' 
					// method on the application scheme 
					// except to send it to the client. 
					// This will economize the network load.
					appScheme.updateImageData("_card1",bd);
					
					break;
				
				case "tap2":
					while(pokerCards._card2._frame.numChildren)
						pokerCards._card2._frame.removeChildAt(0);
					
					pokerCards._card2._frame.addChild(new Bitmap(bitmap));
					
					var bd2:BitmapData=new BitmapData(pokerCards._card2.width,pokerCards._card2.height,true,0x0);
					
					bd2.draw(pokerCards._card2);
					
					appScheme.updateImageData("_card2",bd2);
					break;
				
				case "tap3":
					while(pokerCards._card3._frame.numChildren)
						pokerCards._card3._frame.removeChildAt(0);
					
					pokerCards._card3._frame.addChild(new Bitmap(bitmap));
					
					var bd3:BitmapData=new BitmapData(pokerCards._card3.width,pokerCards._card3.height,true,0x0);
					bd3.draw(pokerCards._card3);
					// After calling 'updateImageData' do not call the 'pageToString' 
					// method on the application scheme 
					// except to send it to the client. 
					// This will economize the network load.
					appScheme.updateImageData("_card3",bd3);
					break;
				
				case "tap4":
					while(pokerCards._card4._frame.numChildren)
						pokerCards._card4._frame.removeChildAt(0);
					
					pokerCards._card4._frame.addChild(new Bitmap(bitmap));
					
					var bd4:BitmapData=new BitmapData(pokerCards._card4.width,pokerCards._card4.height,true,0x0);
					bd4.draw(pokerCards._card4);
					// After calling 'updateImageData' do not call the 'pageToString' 
					// method on the application scheme 
					// except to send it to the client. 
					// This will economize the network load.
					appScheme.updateImageData("_card4",bd4);
					break;
				
				case "tap5":
					while(pokerCards._card5._frame.numChildren)
						pokerCards._card5._frame.removeChildAt(0);
					
					pokerCards._card5._frame.addChild(new Bitmap(bitmap));
					
					var bd5:BitmapData=new BitmapData(pokerCards._card5.width,pokerCards._card5.height,true,0x0);
					bd5.draw(pokerCards._card5);
					// After calling 'updateImageData' do not call the 'pageToString' 
					// method on the application scheme 
					// except to send it to the client. 
					// This will economize the network load.
					appScheme.updateImageData("_card5",bd5);
					
					break;
				
			}
			
			
			// Update the client with econmized serialization 'pageToString'. 
			// Using appScheme.toString() is only required the first time you 
			// validate the data with the session.
			bm.session.updateControlScheme(event.device,appScheme.pageToString(1));
			
			for (var button:String in bm.clientButtonStates[event.device.deviceId])
			{
				trace( "button name ", button, "state ", bm.clientButtonStates[event.device.deviceId][button])
			}
			
			
		}
		
	}
}