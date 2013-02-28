package com.brassmonkey
{
	/**
	 * 
	 * @author Andy Shaules
	 * 
	 */
	public dynamic class LeapFrame
	{
		public var id:Number;
		public var timestamp:Number;
		public var hands:Vector.<LeapHand>=new Vector.<LeapHand>();
		public var pointables:Vector.<LeapFinger>=new Vector.<LeapFinger>();
		private static var _lastTime:Number= 0;
		public static var frameInterval:Number = .0166;
		
		public function getHand(id:int):LeapHand
		{
			if(hands.length>id)
			{
				return hands[id] ;
			}
			return null;
		}
		
		public static function create(obj:Object):LeapFrame
		{
			
			
			var tTime:Number = new Number(obj.timestamp)/1000000.0;
			
			if(tTime<_lastTime || _lastTime==0)
			{
				_lastTime=tTime;
			}
			else
			{
				if((tTime -_lastTime ) < frameInterval)
				{
					return null;
				}
			}
			
			trace("-----------------------");
			
			_lastTime=tTime;
			
			var ret:LeapFrame=new LeapFrame();
			ret.timestamp=tTime;
			
			for(var prop:String in obj){
				trace(prop,obj[prop]);
				if(prop=="hands" )
				{
					for (var h:int=0;h< obj[prop].length;h++)
					{
						
						ret.hands.push(LeapHand.create(obj[prop][h]));
					}
				}
				else if(prop=="timestamp" )
				{
					continue;
				}
				else if(prop =='pointables')
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
				else
				{
					ret[prop]=obj[prop];
				}
			}
			return ret;
			
		}
		public function toString():String
		{
			var ret:String="";
			
			ret+="[LeapFrame Object]"+id+" : "+(timestamp/10000000)+":"+ " Hands-" + hands.length;
			return ret;
			
		}
	}
}