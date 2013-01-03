package invawayders.data
{
	import flash.geom.*;
	
	/**
	 * Data class for Bug Invawayder
	 */
	public class BugInvawayderData extends InvawayderData
	{
		public function BugInvawayderData()
		{
			id = InvawayderFactory.BUG_INVAWAYDER;
			
			cellDefinitions = Vector.<Vector.<uint>>([
				Vector.<uint>([
					0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0,
					0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0,
					0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1,
					1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1,
					0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0
				]),
				Vector.<uint>([
					0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0,
					1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1,
					1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1,
					1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
					0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0,
					0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0
				])
			]);
			
			dimensions = new Point( 11, 8 );
			
			life = 2;
			
			spawnRate = 10000;
			
			fireRate = 1500;
			
			panAmplitude = 250;
			
			speed = 50;
			
			scale = 1;
			
			score = 30;
		}
	}
}
