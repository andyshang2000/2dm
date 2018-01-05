package zz2d.modules.makeup
{
	import fairygui.GComponent;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.event.GTouchEvent;

	import zz2d.ui.util.GViewSupport;

	public class ToolBar extends GComponent
	{
		private var selectedTool:GObject;

		public var selected:Tool;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			for (var i:int = 0; i < numChildren; i++)
			{
				var comp:Tool = getChildAt(i) as Tool;
				if (comp != null)
				{
					addClickListener(comp);
				}
			}
		}

		private function addClickListener(comp:Tool):void
		{
			comp.addEventListener(GTouchEvent.BEGIN, function():void
			{
				if (selected != null)
				{
					selected.enabled = true;
					selected.unuse()
					selected.addChild(selectedTool);
					selectedTool.setXY(0, 1120);
				}
				selected = comp;
				selected.useTool();
				selectedTool = comp.getChild("tool");
				GRoot.inst.addChild(selectedTool);
				dispatchEventWith("change");
				comp.enabled = false;
			});
		}

		public function prev():Boolean
		{
			if (getController("c1").selectedIndex > 0)
			{
				getController("c1").selectedIndex -= 1;
				return true
			}
			else
				return false;
		}

		public function next():Boolean
		{
			if (getController("c1").selectedIndex < getController("c1").pageCount - 1)
			{
				getController("c1").selectedIndex += 1;
				return true
			}
			else
				return false;
		}
	}
}
