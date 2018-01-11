package zz2d.ui.view
{
	import com.greensock.TweenLite;

	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.utils.setTimeout;

	import fairygui.GButton;
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

	import zz2d.game.Game;
	import zz2d.game.Item;
	import zz2d.ui.util.GViewSupport;
	import zz2d.ui.window.Sign;

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
		[G]
		public var settingsButton:GButton;

		private var clothes:Array;

		private var faceTexture:Texture;
		private var face:GImage;
		private var cameraIndex:int = 0;

		[Handler(clickGTouch)]
		public function replayButtonClick():void
		{
			showLoading();
			nextScreen(MakeupScreen);
		}

		[G]
		public var cameraButton:GButton;

		[Handler(clickGTouch)]
		public function cameraButtonClick():void
		{
			if (cameraButton.getController("c1").selectedPage == "camera" || //
				cameraButton.getController("c1").selectedPage == "switchCamera")
			{
				var nameList:Array = Camera.names;
				var camera:Camera = Camera.getCamera(nameList[cameraIndex % nameList.length]);
				cameraIndex++;
				if (cameraIndex == nameList.length)
				{
					cameraButton.getController("c1").selectedPage = "toCartoon"; //"cameraSwitch";
				}
				else
				{
					cameraButton.getController("c1").selectedPage = "switchCamera";
				}
				VideoFace(model.getChild("videoFace")).attachCamera(camera);
				VideoFace(model.getChild("videoFace")).visible = true;
			}
			else if (cameraButton.getController("c1").selectedPage == "toCartoon")
			{
				cameraButton.getController("c1").selectedPage = "camera"
				cameraIndex = 0;
				VideoFace(model.getChild("videoFace")).attachCamera(null);
				VideoFace(model.getChild("videoFace")).visible = false;
			}
		}

		[Handler(clickGTouch)]
		public function nextPageClick():void
		{
			getController("gameState").selectedPage = "show";
			model.getController("gameState").selectedPage = "show";
			VideoFace(model.getChild("videoFace")).snap();
		}

		[Handler(clickGTouch)]
		public function signButtonClick():void
		{
			Sign.show();
		}

		[G]
		public var soundSwitch:SoundSettings;

		[Handler(clickGTouch)]
		public function settingsButtonClick():void
		{
			if (soundSwitch.getController("c1").selectedIndex != 1)
			{
				soundSwitch.getController("c1").selectedIndex = 1;
					//				GRoot.inst.addEventListener(GTouchEvent.BEGIN, function():void
					//				{
					//					GRoot.inst.removeEventListener(GTouchEvent.BEGIN, arguments.callee);
					//					soundSwitch.getController("c1").selectedIndex = 2;
					//				});
			}
			else
			{
				soundSwitch.getController("c1").selectedIndex = 2;
			}
		}

		UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/VideoFace", VideoFace);

		override protected function onCreate():void
		{
			setTimeout(hideLoading, 500);
			setGView("zz2d.dressup.gui", "Dressup");
			GViewSupport.assign(this);
			fit(model);
			VideoFace(model.getChild("videoFace")).visible = false;
			if (Camera.names.length < 1)
			{
				cameraButton.visible = false;
			}
			try
			{
				faceTexture = getTransferParams()[0];

				model.addChildAt(face = new GImage, model.getChildIndex(model.getChild("videoFace")));
				face.setScale(98 / 277, 98 / 277);
				face.setXY(138, 10);
				face.texture = faceTexture;
			}
			catch (err:Error)
			{
			}
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
					BuySupport.promptBuy(item, event.itemObject.asCom);
				}
				else
				{
					if (model.getController(selected).getPageName(0) == "default")
					{
						model.getController(selected).selectedIndex = i;
					}
					else
					{
						model.getController(selected).selectedIndex = i + 1;
					}
					Particle(model.getChild("particle")).start();
				}
			});

			catBar.getController("buttonGroup").addEventListener("stateChanged", function():void
			{
				updateSelectedCat();
			});
			updateSelectedCat();
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
			if (selected == "hair")
			{
				var rect:Rectangle = getFitRect(model, 2.2);
//				TweenLite.to(model, 0.5, {x: rect.x, y: rect.y, scaleX: 2.2, scaleY: 2.2});
			}
			else
			{
				var rect:Rectangle = getFitRect(model, 1);
				trace(rect);
//				TweenLite.to(model, 0.5, {x: rect.x, y: rect.y, scaleX: 1, scaleY: 1});
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
