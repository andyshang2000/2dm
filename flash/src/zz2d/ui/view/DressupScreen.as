package zz2d.ui.view
{
	import com.greensock.TweenLite;

	import flash.utils.setTimeout;

	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GImage;
	import fairygui.GList;
	import fairygui.GLoader;
	import fairygui.GMovieClip;
	import fairygui.GObject;
	import fairygui.GTextField;
	import fairygui.UIObjectFactory;
	import fairygui.UIPackage;
	import fairygui.event.ItemEvent;

	import starling.textures.Texture;

	import zz2d.game.Buy;
	import zz2d.game.Game;
	import zz2d.game.Item;
	import zz2d.ui.util.GViewSupport;

	public class DressupScreen extends GScreen implements IScreen
	{
		[G]
		public var list:GList;
		[G]
		public var catBar:GComponent
		[G]
		public var model:GComponent
		[G]
		public var coinField:GTextField;

		private var clothes:Array;

		private var faceTexture:Texture;
		private var face:GImage;

		[Handler(clickGTouch)]
		public function replayButtonClick():void
		{
			showLoading();
			nextScreen(MakeupScreen);
		}

		[Handler(clickGTouch)]
		public function toShowButtonClick():void
		{
			getController("gameState").selectedPage = "show";
			model.getController("gameState").selectedPage = "show";
		}

		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/VideoFace", VideoFace);

		override protected function onCreate():void
		{
			setTimeout(hideLoading, 500);
			setGView("zz2d.dressup.gui", "Dressup");
			GViewSupport.assign(this);
			fit(model);
			faceTexture = getTransferParams()[0];
			model.addChild(face = new GImage);
			face.setScale(98 / 277, 98 / 277);
			face.setXY(138, 10);
			face.texture = faceTexture;
			list.itemRenderer = function(i:int, r:GComponent):void
			{
				var selected:String = catBar.getController("buttonGroup").selectedPage;
				var loader:GLoader = r.getChild("loader").asLoader;
				var unlockMovie:GMovieClip = r.getChild("unlockMovie").asMovieClip;
				var name:String = clothes[i];
				var url:String = UIPackage.getItemURL("zz2d.dressup.gui", name);
				var item:Item = Game.inventory.getItem(selected, i);
				loader.url = url;
				if (item.amount < 1)
				{
					unlockMovie.visible = true;
				}
				else
				{
					unlockMovie.visible = false;
				}
			};
			list.addEventListener("itemClick", function(event:ItemEvent):void
			{
				var selected:String = catBar.getController("buttonGroup").selectedPage;
				var i:int = list.childIndexToItemIndex(list.getChildIndex(event.itemObject));
				var item:Item = Game.inventory.getItem(selected, i);
				if (item.amount < 1)
				{
					promptBuy(item, event.itemObject.asCom);
				}
				else
				{
					model.getController(selected).selectedIndex = i + 1;
					Particle(model.getChild("particle")).start();
				}
			});

			catBar.getController("buttonGroup").addEventListener("stateChanged", function():void
			{
				updateSelectedCat();
			});
			updateSelectedCat();
		}

		private function promptBuy(item:Item, rendererComp:GComponent):void
		{
			if (Game.money.afford(item.cost))
			{
				trace("buy buy buy");
				if (new Buy(item).execute())
				{
					var unlockMovie:GMovieClip = rendererComp.getChild("unlockMovie").asMovieClip;
					unlockMovie.setPlaySettings(0, -1, 1, -1, function():void
					{
						TweenLite.to(unlockMovie, 0.5, {alpha: 0, onComplete: function():void
						{
							unlockMovie.visible = false;
						}});
					});
				}
			}
			else
			{
				trace("cannot afford")
			}
		}

		private function updateSelectedCat():void
		{
			var selected:String = catBar.getController("buttonGroup").selectedPage;
			var group:GGroup = model.getChild(selected).asGroup;
			clothes = [];
			if (group != null)
			{
				for (var i:int = 0; i < model.numChildren; i++)
				{
					var child:GObject = model.getChildAt(i)
					if (child.group == group)
					{
						clothes.push(child.packageItem.name);
					}
				}
			}
			list.numItems = clothes.length;
		}

		private function int2str(i:int):String
		{
			if (i <= 1)
				return "";
			return i + "";
		}
	}
}
