package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.context.ContextMenuIcon;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.controls.writer.BMContextMenu;
	import com.brassmonkey.controls.writer.BMContextMenuOption;
	import com.brassmonkey.events.DeviceEvent;
	import com.playbrassmonkey.demo.NBaac;
	import com.thebitstream.view.BaseAudio;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	[SWF(width="372",height="372", backgroundColor="#000066")]
	public class ControlMenu extends Sprite
	{
		/**
		 * Brassmonkey session interface 
		 */		
		public var lan:BMApplication;
		/**
		 * Radio skin display 
		 */		
		public var baseSkin:BaseAudio = new BaseAudio();
		/**
		 * Radio sound source. 
		 */		
		public var radio:NBaac;
		/**
		 * Client application control scheme. 
		 */		
		public var appScheme:AppScheme;
		/**
		 * Main control scheme context menu. 
		 */		
		public var menu:BMContextMenu ;
		/**
		 * Menu Item for toggling Music 
		 */		
		public var toggleMusicOption:BMContextMenuOption;
		/**
		 * A secondary scheme context menu. 
		 */		
		public var settingsMenu:BMContextMenu;
		/**
		 * Radio volume settings. 
		 */		
		private var _volOn:Number = 1;
	
		public function ControlMenu()
		{			
			//add the radio skin.
			addChild(baseSkin);
			baseSkin.y=25;
			//create the shoutcast radio music source.
			radio = new NBaac();
			// use enterframe to update radio skin display with radio source time value.
			addEventListener(Event.ENTER_FRAME, onFrame);
			// Change the text displayed in the radio skin.
			baseSkin.metaData={
				url:"",
				name:"Radiocafe",
				description:"Game controller demo.",
				StreamTitle:"Brassmonkey Classics"
			};
					
			//create brassmonkey interface.
			lan= new BMApplication(loaderInfo.parameters);
			//initiate the display name and maximum clients.
			lan.initiate("Control Menu", 1);
			
			//when a device connects, we want to add additional handlers to it.
			//Add a listener for the connection event.
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onLoaded);
			
			//create a scheme clip
			var menuDemoScheme:MenuDemoScheme=new MenuDemoScheme();
			//parse the scheme, and add the actual design orientation, width and height.
			appScheme = BMControls.parseDynamicMovieClip(menuDemoScheme,false,true,'portrait',320,480);
			
			//appScheme = BMControls.parseDynamicMovieClip(menuDemoScheme,false,true,'landscape',480,320);
			
			//Here we begin to construct our primary control pad menu.
			//make a new control pad menu context object
			menu=new BMContextMenu();
			//Next we will add the context items to the game pad menu.
			// First a sound off/on pair. 
			toggleMusicOption = new BMContextMenuOption();
			//display text
			toggleMusicOption.title="Turn Music Off";
			//icon number.
			toggleMusicOption.icon=ContextMenuIcon.MusicOn;
			//script name.
			toggleMusicOption.event="musicToggle";
			//Pressing will close control menu?
			toggleMusicOption.close=false;
			
			//Add the item to the menu
			menu.addOption(toggleMusicOption);
			
			//next we will set up an option to open up the secondary menu.
			var item6:BMContextMenuOption = new BMContextMenuOption();
			item6.title="Choose Preferences";
			item6.icon=ContextMenuIcon.Default;
			item6.event="settings";
			item6.close=false;			
			menu.addOption(item6);
			
			// and finally an item to close the menu and return to game.
			var item5:BMContextMenuOption = new BMContextMenuOption();
			item5.title="Back to game";
			item5.icon=ContextMenuIcon.Reset;
			item5.event="backToGame";
			//This one will close the menu.
			item5.close=true;
			
			menu.addOption(item5);				
			
			//Here we will setup the secondary menu.
			// A game pad menu object is created.
			settingsMenu=new BMContextMenu();
			
			// The secondary option itemsare created and added.
			var item3:BMContextMenuOption = new BMContextMenuOption();
			item3.title="Preference 1";
			item3.icon=ContextMenuIcon.Default;
			item3.event="useWidget"
			//will close the menu.
			item3.close=true;	
			settingsMenu.addOption(item3);
			
			var item4:BMContextMenuOption = new BMContextMenuOption();
			item4.title="Preference 2";
			item4.icon=ContextMenuIcon.Default;
			item4.event="useMain";
			//will close the menu.
			item4.close=true;	
			settingsMenu.addOption(item4);
			
			// Another item is created to take us back to the first menu.
			var item7:BMContextMenuOption = new BMContextMenuOption();
			item7.title="Back";
			item7.icon=ContextMenuIcon.Reset;
			item7.event="backToMain";
			item7.close=false;	
			settingsMenu.addOption(item7);
			
			//Add the Primary menu to the application scheme object child list.
			appScheme.addChild(menu);
					
			//Finally, add the controls into the session for use with the device clients.

			lan.session.registry.validateAndAddControlXML(appScheme.toString());
			
			//start the device discovery.
			lan.start();
			
			// add the color indicator to the stage.
			lan.session.getSlotDisplay().x=20;
			lan.session.getSlotDisplay().y=175;
			addChild(lan.session.getSlotDisplay());
		}

		/**
		 * Device has been loaded and ready for scripting. 
		 * @param de
		 * 
		 */		
		public function onLoaded(de:DeviceEvent):void
		{
			de.device.addEventListener(DeviceEvent.MENU_OPEN, onMenuOpen);
			de.device.addEventListener(DeviceEvent.MENU_CLOSED, onMenuClosed);
			//add a listener for a context menu event.
			de.device.addEventListener(DeviceEvent.CONTEXT_MENU, onMenuSelect);
		}
		
		protected function onMenuClosed(event:DeviceEvent):void
		{
			trace( event.device.controlMenuOpen);
		
			
		}
		
		protected function onMenuOpen(event:DeviceEvent):void
		{
			trace( event.device.controlMenuOpen);
			
		}
		/**
		 * The device event value will be the name of the menu item pressed. 
		 * @param event
		 * 
		 */		
		protected function onMenuSelect(event:DeviceEvent):void
		{
			trace(event.value);
			
			switch(event.value)
			{
				case "musicToggle":
					
					// Is the sound on?
					if(_volOn!=0)
					{
						_volOn=0;
						// Change Music Toggle Item text to indicate what 
						// it will do when pressed the next time
						toggleMusicOption.title="Turn Music On";
						// Change the Menu Item Icon to match the current state
						toggleMusicOption.icon=ContextMenuIcon.MusicOff;
					} 
					// Is the sound off?
					else 
					{
						_volOn=1;
						
						// Change Music Toggle Item text to indicate what 
						// it will do when pressed the next time
						toggleMusicOption.title="Turn Music Off";
						// Change the Menu Item Icon to match the current state
						toggleMusicOption.icon=ContextMenuIcon.MusicOn;
					}
					
					// Update the control scheme to match new state.
					lan.session.updateControlScheme(event.device,appScheme.pageToString(1));
					
					//update radio volume
					if(radio.transportStream)	
						radio.transportStream.soundTransform=new SoundTransform(_volOn);
				break;
				
				
				case "settings":
					//change menu to secondary 
					//remove primary menu. 
					appScheme.removeChildByName("menu");
					//add the secondary. 
					appScheme.addChild(settingsMenu);
					// Send the app-scheme in its present state to this client.
					lan.session.updateControlScheme(event.device,appScheme.pageToString(1));
					
					break;
				
				case "useMain":
				case "useWidget":	
				case "backToMain":
					//All of these actions close the context menu, so lets reset to the primary menu options.
					//remove secondary menu.
					appScheme.removeChildByName("menu");
					//add back primary menu.
					appScheme.addChild(menu);
					//send to this device client.
					lan.session.updateControlScheme(event.device,appScheme.pageToString(1));
					
					break;
			}
		}
		
		protected function onFrame(event:Event):void
		{
			//update the time-value in the radio player skin with the netstream value.
			if(radio.transportStream)		
				baseSkin.time = radio.transportStream.time;
			
		}

	}
}