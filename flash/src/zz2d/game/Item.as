package zz2d.game
{

	public class Item
	{
		public var cat:String;
		public var cost:Money;
		public var amount:int;
		
		public function getPrice():Money
		{
			return cost;
		}
	}
}
