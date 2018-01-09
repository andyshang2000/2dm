package zz2d.ui.view
{
	import fairygui.GComponent;
	import fairygui.GTextField;

	import zz2d.game.Game;
	import zz2d.ui.util.GViewSupport;

	public class BalanceView extends GComponent
	{
		[G]
		public var coinField:GTextField;

		[Handler(clickGTouch)]
		public function addCoinButtonClick():void
		{
			trace("watch video to get free coin");
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			syncMoney();
			Game.money.addEventListener("change", function():void
			{
				syncMoney();
			})
		}

		private function syncMoney():void
		{
			coinField.text = Game.money.m1 + "";
		}
	}
}
