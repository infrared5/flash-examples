package com.brassmonkey
{
	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public class LeapFinger
	{
		public var id:int;
		
		public var length:Number;
		
		public var width:Number;
		
		public var tool:Boolean;
		
		public var tip:LeapFingerTip;
		
		public static function create(obj:Object):LeapFinger
		{
			var ret:LeapFinger=new LeapFinger();
			
			for(var prop:String in obj)	
			{
				if(prop =='tip')
				{
					ret.tip=LeapFingerTip.create(obj[prop]);
				}
				else if(prop =='tool')
				{
					ret[prop]=new Boolean(obj[prop]);
				}
				else
				{
					ret[prop]= obj[prop];
				}
			}
			return ret;
			
		}
	}
}