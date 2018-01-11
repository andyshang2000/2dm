package zz2d.ui.window
{
	import fairygui.GComponent;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.Window;

	import zz2d.ui.util.GViewSupport;

	public class NotEnoughCoinPrompt extends Prompt
	{

		public static var pack:String = "zz2d.dressup.gui";
		public static var item:String = "NotEnoughCoinPrompt";

		private var callback:Function;
		private var getCoinCallback:Function;

		[Handler(clickGTouch)]
		public function yesButtonClick():void
		{
			if (callback != null)
			{
				callback();
			}
			win.hide();
		}

		[Handler(clickGTouch)]
		public function videoButtonClick():void
		{
			if (getCoinCallback != null)
			{
				getCoinCallback();
			}
			win.hide();
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		public static function show():NotEnoughCoinPrompt
		{
			return Prompt.show(NotEnoughCoinPrompt);
		}

		public function onOkClick(callback:Function):NotEnoughCoinPrompt
		{
			this.callback = callback;
			return this;
		}

		public function onGetCoinClick(callback:Function):NotEnoughCoinPrompt
		{
			this.getCoinCallback = callback;
			return this;
		}
	}
}
