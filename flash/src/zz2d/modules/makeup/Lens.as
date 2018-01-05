package zz2d.modules.makeup
{
	import fairygui.Controller;

	public class Lens extends PaintingTool
	{
		public function Lens()
		{
			super();
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			hide();
		}

		override public function updateOption(c:Controller, i:int):void
		{
			c.selectedIndex = i + 1;
		}
	}
}
