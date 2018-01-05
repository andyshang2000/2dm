package zz2d.ui.view
{
	import fairygui.GObject;
	import fairygui.display.UIImage;

	import starling.extensions.pixelmask.PixelMaskDisplayObject;

	public class PixelMaskComp extends GObject
	{
		private var container:PixelMaskDisplayObject;

		public function PixelMaskComp()
		{
			super();
		}

		override protected function createDisplayObject():void
		{
			container = new PixelMaskDisplayObject(1, false);
			setDisplayObject(container);
		}

		public function addsource(image:UIImage):void
		{
			container.addChild(image);
		}
	}
}
