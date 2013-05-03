package
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.brassmonkey.LeapFrame;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.setTimeout;

	[SWF (width="800", height="600", backgroundColor="#000000")]
	public class Tools extends Sprite
	{
		
		public var sp:Sprite=new Sprite();
		public var sp2:Sprite=new Sprite();
		private var cam:Camera;
		private static  var vid:Video;
		
		public function Tools()
		{
			super();

			
			
			cam = Camera.getCamera();
			cam.setMode(640,480,10);
			vid=new Video(640,480);
			vid.attachCamera(cam);
			addChild(vid);
			addChild(sp2);
			addChild(sp);
			vid.width=800;
			vid.height=600;
			
			
			this.stage.addEventListener(MouseEvent.CLICK, onCLick);
		//	sp.graphics.lineStyle(1,0x000000);
		//	addChild(sp);
			ExternalInterface.addCallback("onLeapData", onLeapData);
			
			ExternalInterface.addCallback("onLeapOpen", onLeapOpen);
			
			ExternalInterface.call("init");
		}
		

		
		public static function makeBitmap():BitmapData
		{
			var bd:BitmapData=new BitmapData(320,240,true,0x0);
			bd.draw(vid);
			return bd;
		}
		
		protected function onCLick(event:MouseEvent):void
		{
			stage.displayState= StageDisplayState.FULL_SCREEN;
			
		}
		
		private function onLeapData(data:String):void
		{
			//trace(data);
			var js:JSONDecoder=new JSONDecoder(data);
			var leapData:Object=js.getValue();
			if(leapData.hasOwnProperty('version'))
			{
				flash.utils.setTimeout(ExternalInterface.call,200,'enableGestures');
				//ExternalInterface.call("enableGestures");
			}
			if(leapData.hasOwnProperty('pointables'))
			{
				var pointables:Array = leapData.pointables;
				for each(var pointa:Object in pointables)
				{
					if(sp2.getChildByName(pointa.id)==null)
					{
						sp2.addChild(new FingerTip(pointa,makeBitmap()))	;
						var ff:FingerTip = sp2.getChildByName(pointa.id) as FingerTip;
						
						ff.sp.graphics.lineTo(pointa.tipPosition[0]+400, 600-pointa.tipPosition[1] );
					}
					else
					{
						var fff:FingerTip = sp2.getChildByName(pointa.id) as FingerTip;
						fff.sp.graphics.lineTo(pointa.tipPosition[0]+400, 600-(pointa.tipPosition[1]*2 ));
					}
				
					
					//if(pointables[0].tipPosition[2]<0)
					//sp.graphics.lineTo(pointables[0].tipPosition[0]+400, 600-pointables[0].tipPosition[1] );
					
				}
			}
			if(leapData.gestures)
			{
				var gest:Array = leapData.gestures;
				if(gest.length==0)
					return;
				
				for each (var obj:Object in gest)
				{
					if(obj.type=="swipe")
					{
						while(sp2.numChildren)
						{
							sp2.removeChildAt(0);
						}
						while(sp.numChildren)
						{
							sp.removeChildAt(0);
						}
					}
					if(obj.type=="circle")
					{
						//sp.graphics.clear();
						//sp.graphics.moveTo(400,300);
						//sp.graphics.lineStyle(1,0x000000);
						var v:Array=[];
						if(this.sp.getChildByName(obj.id)==null)
						{

							while(sp2.numChildren)
							{
								sp2.removeChildAt(0);
							}
							
							
							sp.addChild(new ParticleDrop(obj,makeBitmap()));
						}
 
					}
				}
				
			}
			//var leapFrame:LeapFrame=LeapFrame.create(leapData);
			
			
		}
		private function onLeapOpen(data:Object):void
		{
			trace("onLeapOpen , we can use leap-motion for input");
	
			
		}
		
	}
}