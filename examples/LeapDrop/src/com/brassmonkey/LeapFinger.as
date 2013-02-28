package com.brassmonkey
{
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public class LeapFinger
	{
		public var handId:int;
		public var id:int;
		public var length:Number;
		
		public var width:Number;
		
		public var tool:Boolean;

		
		public var direction:Vector3D=new Vector3D();
		
		public var tipPosition:Vector3D=new Vector3D();
		
		public var tipVelocity:Vector3D=new Vector3D();
		
		public static function create(obj:Object):LeapFinger
		{
			var ret:LeapFinger=new LeapFinger();
			
			for(var prop:String in obj)	
			{
				trace("--pointable \t\t",prop,obj[prop]);
				if(prop =='tool')
				{
					ret[prop]=new Boolean(obj[prop]);
				}
				else if(prop =='id'|| prop =='handId' || prop =='length' || prop =='width' )
				{
					ret[prop]= obj[prop];
				}
				else
				{
					var nums:Array=obj[prop];
					
					ret[prop].x=nums[0];
					ret[prop].y=nums[1];
					ret[prop].z=nums[2];	
				}
			}
			return ret;
			
		}
	}
}