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
		public var radius:Number;
		
		public var center:Vector3D=new Vector3D();
		
		public var direction:Vector3D=new Vector3D();
		
		public var normal:Vector3D=new Vector3D();
		
		public var position:Vector3D=new Vector3D();
		
		public var velocity:Vector3D=new Vector3D();

		public static function create(obj:Object):LeapPalm
		{
			var ret:LeapPalm=new LeapPalm();
			
			for(var prop:String in obj)	
			{
			
				if(prop =='radius')
				{
					ret.radius=obj[prop];
				}
				else if(prop =='ball')
				{
					var ballInfo:Object=obj[prop];
					
					for(var info:String in ballInfo)	
					{
						
						if(info =='radius')
						{
							ret.radius=ballInfo[info];
						}
						else if(prop =='center')
						{
							var bNums:Array=ballInfo[info];		
							ret[prop].x=bNums[0];
							ret[prop].y=bNums[1];
							ret[prop].z=bNums[2];	
						}
					}
					
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