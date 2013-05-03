package
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FingerTip extends Sprite
	{
		public var sp:Shape=new Shape();
		public var bufferedImage:BitmapData;
		public function FingerTip(obj:Object, image:BitmapData)
		{
			super();
			bufferedImage=image;
			addChild(sp);
			sp.graphics.clear();
			sp.graphics.lineStyle(10,0xffFFFF*Math.random());
			sp.graphics.moveTo((obj.tipPosition[0]+400), 600-(obj.tipPosition[1]*2));
			sp.graphics.beginBitmapFill(bufferedImage);
			this.name=new String(obj.id);
			
			//this.addEventListener(Event.ENTER_FRAME, onFrame);
			
			
		}
		
		protected function onFrame(event:Event):void
		{
			this.alpha-=.01;
			
			if(alpha<=0){
				if(this.parent)
				{
					this.parent.removeChild(this);
				}
			}
			
		}
	}
}