package zz2d.ui.view
{
	import com.greensock.TweenLite;
	
	import fairygui.GComponent;
	import fairygui.GTextField;
	
	import zz2d.game.Game;
	import zz2d.ui.util.GViewSupport;
	import zz2d.ui.window.FreeCoin;

	public class BalanceView extends GComponent
	{
		[G]
		public var coinField:GTextField;

		[Handler(clickGTouch)]
		public function addCoinButtonClick():void
		{
			FreeCoin.show();
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
			var base:Number = Number(coinField.text)
			var gap:Number = Game.money.m1 - base;
			var tween:TweenLite = TweenLite.to(coinField, 0.5, {onUpdate: function():void
			{
				coinField.text = (int(gap * tween.ratio) + base) + "";
			}, onComplete: function():void
			{
				coinField.text = Game.money.m1 + "";
			}});
		}
	}
}
