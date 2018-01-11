package zz2d.ui.window
{
	import payment.ane.PaymentANE;

	public class FreeCoin extends Prompt
	{
		public static var pack:String = "zz2d.dressup.gui";
		public static var item:String = "FreeCoin";

		private var watchVideoCallback:Function;

		[Handler(clickGTouch)]
		public function closeButtonClick():void
		{
			win.hide();
		}

		[Handler(clickGTouch)]
		public function videoButtonClick():void
		{
			if (watchVideoCallback != null)
			{
				watchVideoCallback();
			}
			win.hide();
		}

		[Handler(clickGTouch)]
		public function playMiniGameClick():void
		{
			if (watchVideoCallback != null)
			{
				watchVideoCallback();
			}
			win.hide();
		}

		[Handler(clickGTouch)]
		public function exchangeClick():void
		{
			if (watchVideoCallback != null)
			{
				watchVideoCallback();
			}
			win.hide();
		}

		public static function show(clazz:Class = null):FreeCoin
		{
			var res:FreeCoin = Prompt.show(FreeCoin);
			res.onWatchVideoClick(function():void
			{
				try
				{
					var res:int = PaymentANE.call("showRewardAD");
					if (res == 0)
					{
					}
					else if (res == -1)
					{
						CryPrompt.show();
					}
				}
				catch (err:Error)
				{
				}
			});
			return res;
		}

		public function onWatchVideoClick(callback:Function):FreeCoin
		{
			this.watchVideoCallback = callback;
			return this;
		}
	}
}
