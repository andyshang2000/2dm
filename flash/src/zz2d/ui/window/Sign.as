package zz2d.ui.window
{
	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.Window;
	
	import zz2d.game.Game;
	import zz2d.ui.util.GViewSupport;
	import zz2d.ui.view.CustomWindow;
	import zz2d.ui.view.GScreen;

	public class Sign extends GComponent
	{
		[G]
		public var signButton:GButton;

		private static var win:Window;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			getController("c1").selectedIndex = Game.signRecord.progress;

			if (Game.signRecord.signed)
				signButton.enabled = false;
			else
				signButton.enabled = true;
			signButton.addClickListener(function():void
			{
				if (Game.signRecord.sign())
				{
					getController("c1").selectedIndex = Game.signRecord.progress;
				}
			})
		}

		public static function show():Sign
		{
			if (!win)
			{
				win = new CustomWindow();
				win.contentPane = UIPackage.createObject("zz2d.dressup.gui", "Sign").asCom;
			}
			GScreen.fit(win.contentPane);
			win.show();
			win.centerOn(GRoot.inst);
			return win.contentPane as Sign;
		}
	}
}
