package
{
	public interface IGameInterface
	{
		function brassMonkeyStart():void
		function brassMonkeyRestart():void
		function brassMonkeyPause():void
		function brassMonkeyResume():void
		function brassMonkeyMoveInput(x:Number, y:Number):void
		function clientfire(isFiring:Boolean):void;
	}
}