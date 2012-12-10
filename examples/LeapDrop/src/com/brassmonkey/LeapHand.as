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
		
		public var palm:LeapPalm
		
		public var fingers:Vector.<LeapFinger>=new Vector.<LeapFinger>();
		
		public function getFiner(id:int):LeapFinger
		{
			if(fingers.length>id)
			{
				return fingers[id];
			}
			return null;
		}
		
		public static function create(obj:Object):LeapHand
		{
			var ret:LeapHand=new LeapHand();
			
			for(var prop:String in obj)
			{				
				if(prop=="fingers" )
				{
					var fingers:Array=obj[prop];
					
					for (var h:int=0;h< fingers.length;h++)
					{
						ret.fingers.push(LeapFinger.create(	fingers[h]));						
					}					
				}
				else if(prop=="palm" )
				{
					ret.palm=LeapPalm.create(obj[prop]);
				}
				else
				{					
					ret[prop]=obj[prop];
				}
			}
			return ret;
		}
	}
}