package zz2d.ui.view
{
	import flash.media.Sound;

	import fairygui.GRoot;
	import fairygui.PackageItem;
	import fairygui.UIConfig;
	import fairygui.UIPackage;

	import payment.ane.PaymentANE;

	import starling.extensions.PDParticleSystem;

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
//			nextScreen(DressupScreen);
			nextScreen(MakeupScreen);
			showLoading();
		}

		override protected function onCreate():void
		{
			setGView("zz2d.dressup.gui", "Root");
			fit(getChild("bg"));
			try
			{
				PaymentANE.call("ready");
			}
			catch (err:Error)
			{
			}
			var url:String = UIPackage.getItemURL("zz2d.dressup.gui", "bgm");
			var pi:PackageItem = UIPackage.getItemByURL(url);
			var sound:Sound = pi.owner.getSound(pi);
			if (sound)
			{
				GRoot.inst.playBGM(sound, 1);
			}
		}
	}
}
