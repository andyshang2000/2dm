package zz2d.game
{

	public class Item
	{
		public var cat:String;
		public var cost:Money;
		public var amount:int = 0;
		
		public function getPrice():Money
		{
			return cost;
		}
	}
}
