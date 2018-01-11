package zz2d.ui.view
{
	import com.greensock.TweenLite;
	
	import fairygui.GComponent;
	import fairygui.GMovieClip;
	
	import payment.ane.PaymentANE;
	
	import zz2d.game.Buy;
	import zz2d.game.Game;
	import zz2d.game.Item;
	import zz2d.ui.window.ConfirmPrompt;
	import zz2d.ui.window.CryPrompt;
	import zz2d.ui.window.FreeCoin;
	import zz2d.ui.window.NotEnoughCoinPrompt;

	public class BuySupport
	{
		public function BuySupport()
		{
		}

		public static function promptBuy(item:Item, rendererComp:GComponent):void
		{
			if (Game.money.afford(item.cost))
			{
				if (Game.buyConfirm)
				{
					ConfirmPrompt.show().onOkClick(function():void
					{
						confirmToBuy(item, rendererComp);
					});
				}
				else
				{
					confirmToBuy(item, rendererComp);
				}
			}
			else
			{
				NotEnoughCoinPrompt.show().onGetCoinClick(function():void
				{
					FreeCoin.show();
				});
			}
		}

		private static function confirmToBuy(item:Item, rendererComp:GComponent):void
		{
			if (new Buy(item).execute())
			{
				var unlockMovie:GMovieClip = rendererComp.getChild("unlockMovie").asMovieClip;
				unlockMovie.setPlaySettings(0, -1, 1, -1, function():void
				{
					TweenLite.to(unlockMovie, 0.5, {alpha: 0, onComplete: function():void
					{
						unlockMovie.visible = false;
						unlockMovie.alpha = 1;
					}});
				});
				unlockMovie.playing = true;
			}
		}
	}
}
