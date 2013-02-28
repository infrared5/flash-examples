package
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.brassmonkey.BMApplication;
	import com.brassmonkey.LeapFinger;
	import com.brassmonkey.LeapFrame;
	import com.brassmonkey.LeapHand;
	import com.brassmonkey.controls.BMControls;
	import com.brassmonkey.controls.writer.AppScheme;
	import com.brassmonkey.events.AccelerationEvent;
	import com.brassmonkey.events.DeviceEvent;
	import com.brassmonkey.leap.art.Bomb;
	import com.brassmonkey.leap.art.Bomber;
	import com.brassmonkey.leap.art.Bucket;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import om.brassmonkey.leap.art.Scores;

	/**
	 * This demo shows how to use an external javascript library with brass monkey. 
	 * <p>The Leap Motion device provides an excellent interface to add exciting features to the game experience. 
	 * The device is able to accuratly detect hands and finger positions.</p> 
	 * 
	 * @author Andy Shaules
	 * 
	 */	
	[SWF (width="1024", height="768",bgcolor="#86B3DD" )]
	public class LeapDrop extends Sprite
	{
		//brassmonkey interface.
		public var lan:BMApplication
		
		public var bucketPlayer:String=null;
		public var bomberPlayer:String=null;
		public var logo:LogoAngry=new LogoAngry();

		public var background:Wall=new Wall();
		public var scores:Scores=new Scores();
		public var bucket:Bucket=new Bucket();
		public var bomber:Bomber=new Bomber();
		public var bombs:Vector.<Bomb> = new Vector.<Bomb>();
		
		public var bucketScore:int = 0;
		
		public var bomberScore:int = 0;
		
		public var dropSpeed:Number = 4;
		
		private var _dropTimer:uint = 0;
		private var appScheme:AppScheme;
		
		
		private var bomberDirection:Number=0;
		private var bucketDirection:Number=0;
		[Embed(source="../lib/explode.mp3")]
		private static var BOOM:Class;
		[Embed(source="../lib/catch.mp3")]
		private static var CATCH:Class;		
		public function LeapDrop()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
			
			stage.frameRate=60;
			
			addChild(background);
			
			bucket.y=626;
			bomber.y=83;
			addChild(bomber);
			addChild(bucket);			
			addChild(scores);
			addChild(logo);
			logo.x=310;
			logo.y=315;
			
			scores.y=180;
			
			scores._bomberPlayerName.text="Waiting for player";
			
			scores._bucketPlayerName.text="Waiting for player";
			
			bomber.x=1024/2;
			bucket.x=1024/2;
			bucket.x +=80;

			bucket.hitArea=bucket.hitTester;
		
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame);
			
			_dropTimer=flash.utils.setInterval(dropBomb,1000);
			
			ExternalInterface.addCallback("onLeapData", onLeapData);
			
			ExternalInterface.addCallback("onLeapOpen", onLeapOpen);
	
		}
		
		public function setupBrassmonkey():void
		{
			lan=new BMApplication(loaderInfo.parameters);
			lan.initiate("Angry Quaker",2);
			lan.addEventListener(DeviceEvent.DEVICE_LOADED, onDevice);
			lan.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDevice);
			
			appScheme= BMControls.parseDynamicMovieClip(new BucketControlScheme(),true,false,'landscape',480,320,'nearest');
			
			lan.session.registry.validateAndAddControlXML(appScheme.toString());
			lan.start();	
		}
		
		protected function onDevice(event:DeviceEvent):void
		{
			switch(event.type)
			{
				case DeviceEvent.DEVICE_LOADED:
					if(this.contains(logo))
						removeChild(logo);
					
					event.device.addEventListener(AccelerationEvent.ACCELERATION, onDeviceMove);
					
					lan.session.enableAccelerometer(event.device,true,1/24);
					if(bucketPlayer==null)
					{
						bucketPlayer=event.device.deviceId;
						scores._bucketPlayerName.text=event.device.deviceName;
					}
					else if(bomberPlayer==null)
					{
						bomberPlayer=event.device.deviceId;
						scores._bomberPlayerName.text=event.device.deviceName;
					}
					break;
				
				case DeviceEvent.DEVICE_DISCONNECTED:
					event.device.removeEventListener(AccelerationEvent.ACCELERATION, onDeviceMove);
					
					if(this.lan.session.registry.devices.length==0)
						addChild(logo);
					
					if(bucketPlayer == event.device.deviceId)
					{		
						scores._bucketPlayerName.text="Waiting for player";
						bucketPlayer=null;
					}
					else if(bomberPlayer == event.device.deviceId)
					{
						scores._bomberPlayerName.text="Waiting for player";
						bomberPlayer=null;
					}
					
					break;
			}			
		}
		
		protected function onDeviceMove(event:AccelerationEvent):void
		{
				
			if(event.deviceId==bucketPlayer)
				bucketDirection = event.acceleration.y*20.0;
			if(event.deviceId==bomberPlayer)
				bomberDirection = event.acceleration.y*20.0;
		}
		
		protected function onInit(event:Event):void
		{
			ExternalInterface.call("init");	
			setupBrassmonkey();
		}
		
		private function onLeapOpen(data:Object):void
		{
			trace("onLeapOpen , we can use leap-motion for input");
			//limit our input data rate.
			LeapFrame.frameInterval=1/24;
		}

		private function onLeapData(data:String):void
		{
			
			var js:JSONDecoder=new JSONDecoder(data);
			var leapData:*=js.getValue();
 			var leapFrame:LeapFrame=LeapFrame.create(leapData);
			if(leapFrame==null)
			{//exceeding desired frameInterval.				
				return;
			}
			scores._bomberPlayerName.text="Leap-Motion";
			

				
				if(leapFrame.pointables.length)
				{
					var finger:LeapFinger=leapFrame.pointables[0];
					bomberDirection =finger.tipPosition.x/10.0;

				}
			
		}
		
		protected function onFrame(event:Event):void
		{
			animateBombs();
			
			var moveAmt:Number=bomberDirection;
			moveAmt=moveAmt<-20?-20:moveAmt;
			moveAmt=moveAmt>20?20:moveAmt;
			bomber.x -=moveAmt;
			if(bomber.x<100)
				bomber.x=100;
			if(bomber.x>900)
				bomber.x=900;
			
			
			
			scores._bomberScore.text=this.bomberScore.toString();
			scores._bucketScore.text=this.bucketScore.toString();
			
			this.bucket.x -=bucketDirection;
			if(bucket.x<25)
				bucket.x=25;
			if(bucket.x>1000)
				bucket.x=1000;
			
			
		}
		
		public function dropBomb():void
		{
			var bomb:Bomb=new Bomb();
			if(Math.random()*10 <5)
				bomb.x=bomber.x+80;
			else
				bomb.x=bomber.x-+80;
			
			bomb.y=bomber.y;
			addChild(bomb);
			bombs.push(bomb);
		}
		
		public function animateBombs():void
		{
			for each(var b:Bomb in bombs)
			{
				b.y += dropSpeed;
				
				if(bucket.hitTestObject(b))
				{
					var snd1:Sound=new CATCH();
					snd1.play(0,0,new SoundTransform(.75, b.x/1024- .5));
					bucketScore+=20;					
					bombs.splice(bombs.indexOf(b),1);
					
					removeChild(b);
					b=null;
					continue;	
				}
				
				if(b.y>750)
				{
					var snd2:Sound=new BOOM();
					snd2.play(0,0,new SoundTransform(.5, b.x/1024- .5));
						
					bomberScore+=20;					
					bombs.splice(bombs.indexOf(b),1);
					if(this.contains(b))
					{
						removeChild(b);
						b=null;
					}
				}
			}
		}
	}
}