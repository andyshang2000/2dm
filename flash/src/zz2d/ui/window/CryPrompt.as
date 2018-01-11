package zz2d.ui.window
{
	import flash.utils.setTimeout;

	public class CryPrompt extends Prompt
	{
		public static var pack:String = "zz2d.dressup.gui";
		public static var item:String = "CryPrompt";

		public static function show():CryPrompt
		{
			var res:CryPrompt = Prompt.show(CryPrompt);
			setTimeout(res.win.hide, 2000);
			return res;
		}
	}
}
