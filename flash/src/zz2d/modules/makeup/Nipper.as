package zz2d.modules.makeup
{
	import flash.geom.Point;
	
	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GImage;
	import fairygui.GObject;
	import fairygui.event.GTouchEvent;
	
	import zz2d.ui.util.GViewSupport;
	
	public class Nipper extends Tool
	{
		private var furArr:Array;
		private var toolMask:GObject;
		private var toolPos:Point = new Point;
		
		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
			try
			{
				toolMask = GComponent(tool).getChild("toolMask");
				toolMask.visible = false;
			}
			catch (err:Error)
			{
			}
		}
		
		override protected function onTouch(event:GTouchEvent):void
		{
			super.onTouch(event);
			
			if (!model)
				return;
			
			toolMask.localToRoot(0, 0, toolPos);
			model.rootToLocal(toolPos.x, toolPos.y, toolPos);
			
			var pimpleGroup:GGroup = model.getChild("Nipper").asGroup;
			furArr = getChildrenInGroup(pimpleGroup);
			for each (var p:GImage in furArr)
			{
				var pnt2:Point = new Point(p.x + p.width / 2, p.y + + p.height / 2);
				if (Point.distance(toolPos, pnt2) < 10)
				{
					p.visible = false;
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
import zz2d.modules.makeup;

