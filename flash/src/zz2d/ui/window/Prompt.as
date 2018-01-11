package zz2d.ui.window
{
	import flash.utils.Dictionary;
	
	import fairygui.GComponent;
	import fairygui.UIPackage;
	import fairygui.Window;
	
	import zz2d.ui.util.GViewSupport;
	import zz2d.ui.view.CustomWindow;

	public class Prompt extends GComponent
	{
		private static var windowDic:Dictionary = new Dictionary;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		public function get win():Window
		{
			return windowDic[this["constructor"]];
		}

		public static function show(clazz:Class):*
		{
			var win:Window = windowDic[clazz];
			if (!win)
			{
				win = new CustomWindow();
				windowDic[clazz] = win;
				win.contentPane = UIPackage.createObject(clazz.pack, clazz.item).asCom;
			}
			win.modal = true;
			win.center(true);
			win.show();
			return win.contentPane;
		}
	}
}
