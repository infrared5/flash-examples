package invawayders.data
{
	import invawayders.objects.*;
	
	import flash.geom.*;
	
	/**
	 * Base class for invawayder data types.
	 */
	public class InvawayderData
	{
		/**
		 * The unique id of the invawayder data type.
		 */
		public var id:uint;
		
		/**
		 * The vector data defining the shape of the invawayder data frames.
		 */
		public var cellDefinitions:Vector.<Vector.<uint>>;
		
		/**
		 * The vector data defining the positions in space of each building block 'cell', used for explosions.
		 */
		public var cellPositions:Vector.<Vector.<Point>>;
		
		/**
		 * The dimensions of the cell data.
		 */
		public var dimensions:Point;
		
		/**
		 * The amount of life that the invawayder has when created, that the player has to deplete before it is destroyed.
		 */
		public var life:uint;
		
		/**
		 * The regularity with which the invawayder type spawns.
		 */
		public var spawnRate:uint;
		
		/**
		 * The regularity with which the invawayder fires projectiles.
		 */
		public var fireRate:uint;
		
		/**
		 * The amplitude of the invawayder's movement in the x direction.
		 */
		public var panAmplitude:uint;
		
		/**
		 * The speed of the invawayder's movment in the z direction.
		 */
		public var speed:uint;
		
		/**
		 * The overall scale of the invawayder in the scene.
		 */
		public var scale:Number;
		
		/**
		 * The score awarded to the player on destroying an invawayder.
		 */
		public var score:uint;
		
		/**
		 * The last spawn time in milliseconds of the invawayder type, updated after a new invawayder is spawned.
		 */
		public var lastSpawnTime:uint;
		
		/**
		 * An instance of the 3d object representing the invawader type, from which new invawayders are cloned.
		 * Created the first time the instance of an invawayder type is requested, and used to clone an invawayder for all subsequent instance requests.
		 */
		public var invawayder:Invawayder;
	}
}
