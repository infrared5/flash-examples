package com.brassmonkey
{
	import flash.geom.Vector3D;
	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public class LeapFingerTip
	{
		public var direction:Vector3D=new Vector3D();
		
		public var position:Vector3D=new Vector3D();
		
		public var velocity:Vector3D=new Vector3D();
		
		public static function create(obj:Object):LeapFingerTip
		{
			var ret:LeapFingerTip=new LeapFingerTip();
		
			for(var prop:String in obj)
			{
				var nums:Array=obj[prop];
				
				ret[prop].x=nums[0];
				ret[prop].y=nums[1];
				ret[prop].z=nums[2];			
			}
		
			return ret;
		}
	}
}
