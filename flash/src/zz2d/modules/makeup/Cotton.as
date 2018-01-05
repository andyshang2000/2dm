package zz2d.modules.makeup
{
	import flash.geom.Point;

	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GObject;
	import fairygui.event.GTouchEvent;

	import zz2d.ui.util.GViewSupport;

	public class Cotton extends Tool
	{
		private var pimples:Array;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		override protected function onTouch(event:GTouchEvent):void
		{
			super.onTouch(event);

			if (!model)
				return;

			var pimpleGroup:GGroup = model.getChild("Pimple").asGroup;
			pimples = getChildrenInGroup(pimpleGroup);
			for each (var p:GComponent in pimples)
			{
				var pnt:Point = new Point(tool.x - 34, tool.y - 83);
				var pnt2:Point = new Point(p.x, p.y + 17);
				p.localToRoot(0, 17, pnt2);

				if (Point.distance(pnt, pnt2) < 10)
				{
					if (p.getChild("pimple").alpha < 0.5)
						p.getChild("pimple").alpha = Math.max(0.0, p.getChild("pimple").alpha - 0.05);
				}
			}
		}

		private function getChildrenInGroup(group:GGroup):Array
		{
			var res:Array = [];
			var container:GComponent = group.parent;
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var child:GObject = container.getChildAt(i);
				if (child.group == group)
				{
					res.push(child);
				}
			}
			return res;
		}
	}
}

