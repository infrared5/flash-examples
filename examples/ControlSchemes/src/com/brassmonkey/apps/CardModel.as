package com.brassmonkey.apps
{
	public class CardModel
	{
		import cards.*;
		private var shuffled:Array=[];
		public var deck:Array=[
		new A1(),
		new cards.A2(),
		new cards.A3(),
		new cards.A4(),
		new cards.A5(),
		new cards.A6(),
		new cards.A7(),
		new cards.A8(),
		new cards.A9(),
		new cards.A10(),
		new cards.A11(),
		new cards.A12(),
		new cards.A13(),
		new cards.B1(),
		new cards.B2(),
		new cards.B3(),
		new cards.B4(),
		new cards.B5(),
		new cards.B6(),
		new cards.B7(),
		new cards.B8(),
		new cards.B9(),
		new cards.B10(),
		new cards.B11(),
		new cards.B12(),
		new cards.B13(),
		new cards.C1(),
		new cards.C2(),
		new cards.C3(),
		new cards.C4(),
		new cards.C5(),
		new cards.C6(),
		new cards.C7(),
		new cards.C8(),
		new cards.C9(),
		new cards.C10(),
		new cards.C11(),
		new cards.C12(),
		new cards.C13(),
		new cards.D1(),
		new cards.D2(),
		new cards.D3(),
		new cards.D4(),
		new cards.D5(),
		new cards.D6(),
		new cards.D7(),
		new cards.D8(),
		new cards.D9(),
		new cards.D10(),
		new cards.D11(),
		new cards.D12(),
		new cards.D13()]
		
		public function CardModel()
		{
		}
		public function getCard():int
		{
			var ret:int= Math.round(Math.random()* deck.length);

			
			return ret;
			
		}
		
		
	}
}