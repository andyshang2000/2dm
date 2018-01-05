package zz2d.ui.view
{
	import flash.utils.setTimeout;

	import fairygui.Controller;
	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GImage;
	import fairygui.GList;
	import fairygui.GLoader;
	import fairygui.GObject;
	import fairygui.UIObjectFactory;
	import fairygui.UIPackage;
	import fairygui.event.ItemEvent;

	import starling.textures.RenderTexture;

	import zz2d.modules.makeup.Cotton;
	import zz2d.modules.makeup.Lens;
	import zz2d.modules.makeup.Needle;
	import zz2d.modules.makeup.Nipper;
	import zz2d.modules.makeup.PaintingTool;
	import zz2d.modules.makeup.ToolBar;
	import zz2d.ui.util.GViewSupport;

	public class MakeupScreen extends GScreen implements IScreen
	{
		[G]
		public var toolBar:ToolBar;
		[G]
		public var list:GList;
		[G]
		public var model:GComponent;

		private var rt:RenderTexture;
		private var makeupParts:Array;
		private var facePart:Object = {};

		private var faceTexture:RenderTexture;

		[Handler(clickGTouch)]
		public function prevPageClick():void
		{
			toolBar.prev();
		}

		[Handler(clickGTouch)]
		public function nextPageClick():void
		{
			if (!toolBar.next())
			{
				drawFace();
				nextScreen(DressupScreen, faceTexture);
			}
		}

		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Needle", Needle);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Cotton", Cotton);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Rim", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Nipper", Nipper);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Shadow", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Eyebrow", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Mascara", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Blusher", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Lip", PaintingTool);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Lens", Lens);
		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/ToolBar", ToolBar);

		override protected function onCreate():void
		{
			setGView("zz2d.dressup.gui", "Game");
			GViewSupport.assign(this);
			fit(getChild("model"));

			toolBar.addEventListener("change", function():void
			{
				if (toolBar.selected is PaintingTool)
				{
					if (getController("option").selectedPage == "open")
					{
						getTransition("t1").play();
						setTimeout(changeTool, 500);
					}
					else
					{
						getController("option").selectedPage = "open";
						changeTool();
					}
					setupPaintingTool();
				}
				else
				{
					getController("option").selectedPage = "close";
					changeTool();
				}
			});

			list.itemRenderer = function(i:int, r:GComponent):void
			{
				var loader:GLoader = r.getChild("loader").asLoader;
				var name:String = toolBar.selected.packageItem.name;
				var url:String = UIPackage.getItemURL("zz2d.dressup.gui", name + int2str(i + 1));
				loader.url = url;
			};
			list.addEventListener("itemClick", function(event:ItemEvent):void
			{
				var i:int = list.childIndexToItemIndex(list.getChildIndex(event.itemObject));
				if (toolBar.selected is PaintingTool)
				{
					var name:String = toolBar.selected.packageItem.name;
					var part:GObject = makeupParts[i];
					var controller:Controller = model.getController(name);
					toolBar.selected.updateOption(controller, i);
					PaintingTool(toolBar.selected).setRenderSource(part);
					PaintingTool(toolBar.selected).setRenderSourceRect(part.x, part.y, part.width, part.height);
				}
			});
			changeTool();
		}

		public function drawFace():void
		{
			faceTexture ||= new RenderTexture(480, 800, true);
			for (var i:int = 0; i < model.numChildren; i++)
			{
				var child:GImage = model.getChildAt(i).asImage;

				if (child && (child.texture is RenderTexture || (child.group != null && child.internalVisible)))
				{
					faceTexture.draw(child.displayObject);
				}
			}
		}

		private function setupPaintingTool():void
		{
			var selectedToolName:String = toolBar.selected.packageItem.name;
			if (facePart[selectedToolName] == null)
			{
				var group:GGroup = model.getChild(selectedToolName).asGroup;
				var gImg:GImage = UIPackage.createObject("zz2d.dressup.gui", "Face").asImage;
				rt = new RenderTexture(gImg.width, gImg.height, true, 1);
				rt = new RenderTexture(480, 800, true, 1);
				facePart[selectedToolName] = rt;
				gImg.texture = rt;

				var inGroup:Boolean = false;
				for (var i:int = 0; i < model.numChildren; i++)
				{
					if (model.getChildAt(i).group == group)
					{
						inGroup = true;
					}
					if (inGroup && model.getChildAt(i).group == group)
					{
						break;
					}
				}
				model.addChildAt(gImg, i + 1);
				PaintingTool(toolBar.selected).setRenderTexture(rt);
			}
		}

		private function changeTool():void
		{
			if (toolBar.selected == null)
				return;

			toolBar.selected.setModel(model);

			var selectedToolName:String = toolBar.selected.packageItem.name;
			var group:GGroup;
			try
			{
				group = model.getChild(selectedToolName).asGroup;
			}
			catch (err:Error)
			{
			}
			if (!group)
				return;

			makeupParts = [];
			if (group != null)
			{
				for (var i:int = 0; i < model.numChildren; i++)
				{
					var child:GObject = model.getChildAt(i)
					if (child.group == group)
					{
						child.name = child.packageItem.name;
						makeupParts.push(child);
					}
				}
			}
			list.numItems = makeupParts.length;
		}

		private function int2str(i:int):String
		{
			if (i <= 1)
				return "";
			return i + "";
		}
	}
}