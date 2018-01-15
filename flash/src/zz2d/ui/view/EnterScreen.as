package zz2d.ui.view
{
	import flash.media.Sound;

	import fairygui.GRoot;
	import fairygui.PackageItem;
	import fairygui.UIConfig;
	import fairygui.UIPackage;

	import payment.ane.PaymentANE;

	import starling.extensions.PDParticleSystem;

	import zz2d.game.Game;

	import zzsdk.utils.FileUtil;

	public class EnterScreen extends GScreen implements IScreen
	{
		private var firstRun:Boolean;
		private var _particleSystem:PDParticleSystem;

		override protected function doLoadAssets():void
		{
			UIPackage.addPackage( //
				FileUtil.open("zz2d.dressup.gui"), //
				FileUtil.open("zz2d.dressup@res.gui"));

			UIConfig.buttonSound = UIPackage.getItemURL("zz2d.dressup.gui", "button_normal");
		}

		[Handler(clickGTouch)]
		public function startButtonClick():void
		{
			nextScreen(MakeupScreen);
			showLoading();
		}

		override protected function onCreate():void
		{
			Game.lang = getLanguage();
			UIPackage.setStringsSource(XML(FileUtil.open("locale-" + Game.lang + ".txt")));
			setGView("zz2d.dressup.gui", "Root");
			fit(getChild("bg"));

			var url:String = UIPackage.getItemURL("zz2d.dressup.gui", "bgm");
			var pi:PackageItem = UIPackage.getItemByURL(url);
			var sound:Sound = pi.owner.getSound(pi);
			if (sound)
			{
				GRoot.inst.playBGM(sound, 1);
			}

			try
			{
				PaymentANE.call("ready");
				Game.listen(PaymentANE.extContext)
			}
			catch (err:Error)
			{
			}
			Game.load();
		}

		private static function getLanguage():String
		{
			var res:String = "zh";
			try
			{
				res = PaymentANE.call("getLang");
				if(res != "zh")
				{
					res = "en"
				}
			}
			catch (err:Error)
			{
			}
			return res;
		}
	}
}
