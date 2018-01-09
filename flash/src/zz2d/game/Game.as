package zz2d.game
{
	import zz2d.util.DataUtil;

	public class Game
	{
		public static var money:Money = new Money;
		public static var inventory:Inventory;

		public static function save():void
		{
			money.save();
			inventory.save();
		}

		public static function load():void
		{
			DataUtil.id = "zz2dg";
			DataUtil.load(DataUtil.id);
			if (!inventory)
				inventory = new Inventory;
			money.load();
			inventory.load();
		}
	}
}
