package com.brassmonkey
{
	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public class LeapHand
	{
		public var id:int;
		
		public var palm:LeapPalm=new LeapPalm();
		
		public var pointables:Vector.<LeapFinger>=new Vector.<LeapFinger>();
		
		public function getFiner(id:int):LeapFinger
		{
			if(pointables.length>id)
			{
				return pointables[id];
			}
			return null;
		}
		
		public static function create(obj:Object):LeapHand
		{
			var ret:LeapHand=new LeapHand();
			
			ret.palm=LeapPalm.create(obj);
			

			for(var prop:String in obj)
			{				
				trace(prop,obj[prop]);
				if(prop =='pointables')
				{
					
					if( obj[prop].length > 0 )
					{
						
						for( var j:int = 0; j < obj[prop].length; j++ )
						{                          
							var pointable:LeapFinger =LeapFinger.create( obj[prop][j]);
							ret.pointables.push(pointable);
							
						}
					}
					
				}
			}
			return ret;
		}
	}
}