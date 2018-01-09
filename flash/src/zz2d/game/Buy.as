package zz2d.game
{

	public class Buy
	{
		private var item:*;

		public function Buy(item:*)
		{
			this.item = item;
		}

		public function execute():Boolean
		{
			var price:Money;
			try
			{
				price = item.getPrice();
			}
			catch (err:Error)
			{
				price = new Money;
				price.m1 = item.cost.m1;
				price.m2 = item.cost.m2;
				price.m3 = item.cost.m3;
				price.m4 = item.cost.m4;
				price.m5 = item.cost.m5;
			}
			if (Game.money.afford(price))
			{
				Game.money.substract(price);
				Game.inventory.add(item);
				Game.inventory.save();
				Game.money.save();
				return true;
			}
			return false;
		}
	}
}
