package zz2d.game
{
	import starling.events.EventDispatcher;

	import zz2d.util.DataUtil;

	public class SignRecord extends EventDispatcher
	{
		public var progress:int = 0;
		public var signed:Boolean = false;
		private var bonus:Array = [1000, 1000, 2000, 2000, 3000, 5000, 10000];

		public function sign():Boolean
		{
			if (signed)
				return false;
			if ((progress % 2) == 1)
				return false;
			progress += 1;
			signed = true;
			save();
			Game.money.add(getBonus(progress));
			Game.money.save();
			dispatchEventWith("change");
			return true;
		}

		private function getBonus(progress:int):Money
		{
			var i:int = progress / 2;
			var money:Money = new Money;
			money.m1 = bonus[i];
			return money
		}

		public function save():void
		{
			DataUtil.writeInt("signr", progress);
			DataUtil.writeNumber("signd", new Date().time);
			trace(new Date().time);
			DataUtil.save(DataUtil.id);
			trace(DataUtil.readNumber("signd"));

		}

		public function load():void
		{
			var date:Date = new Date;
			date.time
			var now:Date = new Date;
			progress = DataUtil.readInt("signr");
			date.time = DataUtil.readNumber("signd");
			if (date.time == 0)
			{
				progress = 0;
				signed = false;
				return;
			}
			if (now.fullYear == date.fullYear && now.month == date.month && now.date == date.date)
			{
				signed = true;
			}
			else
			{
				signed = false;
				if (progress % 2 == 1)
					progress += 1;
			}
			dispatchEventWith("change");
		}
	}
}
