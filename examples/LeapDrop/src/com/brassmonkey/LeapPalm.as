package com.brassmonkey
{
	import flash.geom.Vector3D;
	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public class LeapPalm
	{
		
		public var sphereRadius:Number;
		
		public var sphereCenter:Array=[];
		
		public var direction:Array=[];
		
		public var normal:Array=[];
		
		public var palmPosition:Array=[];
		
		public var palmVelocity:Array=[];
		
		public var palmNormal:Array=[];

		
		public static function create(obj:Object):LeapPalm
		{
			var ret:LeapPalm=new LeapPalm();
			
			for(var prop:String in obj)	
			{
				trace(prop, obj[prop]);
				if(ret.hasOwnProperty(prop))
				{
					ret[prop]=obj[prop];
				}
			}
			
			return ret;
		}
	}
}