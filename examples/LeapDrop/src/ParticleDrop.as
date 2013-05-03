package
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ParticleDrop extends Sprite
	{
		
		public var sp:Shape=new Shape();
		
		public var bufferedImage:BitmapData;
		public var obj:Object;
		public function ParticleDrop(obj:Object,Image:BitmapData)
		{
			super();
			this.obj=obj;
			bufferedImage=Image;
			addChild(sp);
			sp.graphics.clear();
			sp.graphics.lineStyle(1,0xffFFFF*Math.random());
			sp.graphics.beginBitmapFill(Image);			
			sp.graphics.drawCircle(obj.center[0]+400,600-obj.center[1], obj.radius);
			sp.graphics.endFill();
			this.name=new String(obj.id);
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			
			
		}
		
		protected function onFrame(event:Event):void
		{

			
			//this.alpha-=.01;
			this.y+=3;
			
			
			if(this.y>=1000 || this.alpha<=0){
				if(this.parent)
				{
					this.parent.removeChild(this);
					bufferedImage.dispose();
				}
			}
			
		}
	}
}