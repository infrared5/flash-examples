package invawayders.data
{
	import flash.geom.*;
	
	/**
	 * Data class for Mothership Invawayder
	 */
	public class MothershipInvawayderData extends InvawayderData
	{
		public function MothershipInvawayderData()
		{
			id = InvawayderFactory.MOTHERSHIP_INVAWAYDER;
			
			cellDefinitions = Vector.<Vector.<uint>>([
				Vector.<uint>([
					0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
					0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0,
					0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0
				]),
				Vector.<uint>([
					0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
					0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0
				])
			]);
			
			dimensions = new Point( 16, 7 );
			
			life = 20;
			
			spawnRate = 120000;
			
			fireRate = 200;
			
			panAmplitude = 0;
			
			speed = 10;
			
			scale = 3;
			
			score = 200;
		}
	}
}
