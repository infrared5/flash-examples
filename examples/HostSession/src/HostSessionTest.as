package
{
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.devices.Device;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.host.HostSession;
	import com.brassmonkey.host.HostSessionEvent;
	import com.brassmonkey.host.ServerDataEvent;
	import com.brassmonkey.host.SessionModel;
	import com.brassmonkey.host.SessionTime;
	import com.brassmonkey.host.domain.UserInfo;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	[SWF(width="960", height="640", pageTitle="My Account", bgcolor="#000000")]
	
	/**
	 * A HostSession gives you a way to retrieve information about a user. 
	 * The most simple usage is to get the user icon they have chosen(if any) 
	 * as a Flash Loader object containing a Bitmap. 
	 * The more advanced usage is to get your secret api key, 
	 * script a handshake response using the jsp or php sample codes, 
	 * and pass the values to the HostSession object's constructor.
	 * <p>If you use your secret api key, you can introduce micro transactions into your game.
	 * You can create a unit-values, inventory items, 
	 * and user-attributes which persist between game sessions, 
	 * and accross all the devices that a user plays on while logged in.
	 * </p> 
	 *  
	 * @author Andy Shaules
	 * 
	 */
	public class HostSessionTest extends Sprite
	{
		public var session:HostSession;
		
		public var lan:BMApplication;
		private var scheme:AppScheme;
		private var iconHolder:Sprite=new Sprite();
		
		public function HostSessionTest()
		{
			
			iconHolder.x=100;
			iconHolder.y=100;
			
			if(this.loaderInfo.parameters.token && this.loaderInfo.parameters.handshake)
			{				
				session=new HostSession();
				session.addEventListener(HostSessionEvent.CONNECTED, onConnected);
				session.addEventListener(ServerDataEvent.DATA, onData);
				session.createSession(this.loaderInfo.parameters.token,
									this.loaderInfo.parameters.handshake,
									SessionTime.HALF_HOUR);
				
			}
			
			lan=new BMApplication(loaderInfo.parameters);
			
			lan.initiate("My account",1,"a65971f24694b9c47a9bcd01");
			
			lan.session.registry.validateAndAddControlXML(BMControls.parseDynamicMovieClip(new MovieClip(),false,false).toString());
			
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDeviceDisconnected);			
			lan.start();
			
			addChild(iconHolder);
		}
		
		
		protected function onDeviceDisconnected(event:DeviceEvent):void
		{
			
			
			while(iconHolder.numChildren)
				iconHolder.removeChildAt(0);
			
		}
		
		
		protected function onDevice(event:DeviceEvent):void
		{
			//two ways to get an icon. try one or the other.
			if(session==null)
			{
				//this one does not require a secret key.
				HostSession.getIconByDevice(event.device, onIcon);
			}
			else
			{
				//the other uses the user-id, so if we havent got that yet, we load the user object by device id.
				session.loadUser(event.device.deviceId);
			}
		}
		
		/**
		 * Object data about a user has been received and parsed. 
		 * Use the event rpc info object to find out which user and call has been received. 
		 * @param event
		 * 
		 */		
		protected function onData(event:ServerDataEvent):void
		{
			var u:UserInfo=null;
			trace(event.info.call);
			switch(event.info.call)
			{
				case HostSession.LOAD_USER:
					u = SessionModel.getUser(event.info.userId);
					trace(u.username);
					session.getIcon(u);						
					break;
				
				
				case HostSession.GET_ICON:
					u = SessionModel.getUser(event.info.userId);
					iconHolder.addChild(u.icon);				
					//session.getProfile(u.id);
					break;
				
				case HostSession.GET_PROFILE:
					u = SessionModel.getUser(event.info.userId);
					//session.getInventory(u.id);
					break; 
				
				case HostSession.GET_INVENTORY:
					u = SessionModel.getUser(event.info.userId);					
					break
				
				
			}
			
		}
		/**
		 *  
		 * @param userDevice that the icon belongs to.
		 * @param userIcon The flash Loader object containing the icon.
		 * 
		 */		
		private function onIcon(userDevice:Device ,userIcon:Loader):void
		{
			iconHolder.addChild(userIcon);
		}
		/**
		 * This is called after the response has been validated 
		 * @param event
		 * 
		 */		
		protected function onConnected(event:HostSessionEvent):void
		{			
			trace("Host Session Connected");	
		}
	}
}