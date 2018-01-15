package zz2d.ui.window
{
	import flash.utils.setTimeout;

	public class SaveImgPrompt extends Prompt
	{
		public static var pack:String = "zz2d.dressup.gui";
		public static var item:String = "SaveImgPrompt";

		public static function show():SaveImgPrompt
		{
			var res:SaveImgPrompt = Prompt.show(SaveImgPrompt);
			setTimeout(res.win.hide, 2000);
			return res;
		}
	}
}
