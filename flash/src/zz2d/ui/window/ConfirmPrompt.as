package zz2d.ui.window
{
	import fairygui.GButton;
	
	import zz2d.game.Game;
	import zz2d.ui.util.GViewSupport;

	public class ConfirmPrompt extends Prompt
	{
		public static var pack:String = "zz2d.dressup.gui";
		public static var item:String = "ConfirmPrompt";

		private var callback:Function;

		[G]
		public var noPromptButton:GButton;

		[Handler(clickGTouch)]
		public function yesButtonClick():void
		{
			if (callback != null)
			{
				callback();
				Game.buyConfirm = !noPromptButton.selected;
				Game.save();
			}
			win.hide();
		}

		[Handler(clickGTouch)]
		public function noButtonClick():void
		{
			win.hide();
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			noPromptButton.selected = !Game.buyConfirm;
		}

		public static function show():ConfirmPrompt
		{
			return Prompt.show(ConfirmPrompt);
		}

		public function onOkClick(callback:Function):void
		{
			this.callback = callback;
		}
	}
}
