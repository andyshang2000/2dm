package zz2d.game
{
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;

	import mx.utils.StringUtil;

	import nblib.util.Reader;

	import zz2d.util.DataUtil;

	public class Inventory extends EventDispatcher
	{
		protected static var json:*;

		private var items:Object = {};
		private var cats:Object = {};

		private function parseLine(line:String):void
		{
			var cursor:int = line.indexOf(":");
			var cat:String = line.substr(0, cursor);
			if (cat == "Money")
			{
				Game.money.m1 = parseInt(line.substr(cursor + 1));
			}
			else
			{
				cats[cat] = [];
				while (cursor != -1 && cursor < line.length - 1)
				{
					cursor = line.indexOf("{", cursor);
					var seg:String = line.substring(cursor + 1, cursor = line.indexOf("}", cursor));
					var item:Item = parseSeg(seg);
					item.cat = cat;
					cats[cat].push(item);
				}
			}
		}

		private function parseSeg(seg:String):Item
		{
			var fields:Array = seg.split(",");
			var item:Item = new Item;
			item.cost = parseCost(fields[1]);
			item.amount = fields[2].toUpperCase() == "Y" ? 1 : 0;
			return item;
		}

		private function parseCost(value:String):Money
		{
			var money:Money = new Money;
			money.m1 = parseInt(value);
			return money;
		}

		public function getItem(cat:String, i:int):Item
		{
			if (!(cats[cat][i] is Item))
			{
				var item:Item = new Item;
				item.amount = cats[cat][i].amount;
				item.cat = cats[cat][i].cat;
				item.cost = new Money;
				item.cost.m1 = cats[cat][i].cost.m1;
				cats[cat][i] = item;
			}
			return cats[cat][i];
		}

		public function load():void
		{
			DataUtil.load(DataUtil.id);
			registerClassAlias("zz2d.game.Item", Item);
			registerClassAlias("zz2d.game.Money", Money);
			cats = DataUtil.readObj("inventory");
			if (!cats)
			{
				cats = {};
				var reader:Reader = Reader.open("first.txt");
				var num:int = 0;
				while (reader.hasNextline())
				{
					var line:String = StringUtil.trim(reader.readLine());
					if (line.length < 1 || StringUtil.isWhitespace(line))
						continue;
					if (line.charAt(0) == "#")
						continue;
					num++
					trace(num + ">" + line);
					parseLine(line);
				}
			}
		}

		public function save():void
		{
			DataUtil.load(DataUtil.id);
			registerClassAlias("zz2d.game.Item", Item);
			registerClassAlias("zz2d.game.Money", Money);
			DataUtil.writeObj("inventory", cats);
		}

		public function hasItem(item:Item):Boolean
		{
			return item.amount > 0;
		}

		public function remove(item:Item):void
		{
			item.amount = 0;
		}

		public function add(item:Item, amount:int = 1):void
		{
			item.amount += amount;
		}
	}
}
