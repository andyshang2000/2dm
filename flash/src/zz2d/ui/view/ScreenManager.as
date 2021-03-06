package zz2d.ui.view
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;

	import fairygui.GComponent;
	import fairygui.GRoot;
	import fairygui.RelationType;
	import fairygui.UIPackage;

	import zz2d.ui.RenderManager;

	[Event(name = "complete", type = "flash.events.Event")]
	public class ScreenManager extends Sprite
	{
		private var currentScreen:IScreen;
		public var renderManager:RenderManager;
		private var params:Array;
		private var defaultLoadingName:String = "LoadingScene";
		private var defaultPackage:String = "zz2d.dressup.gui";
		private var loadingScene:GComponent;

		public function ScreenManager(stage:Stage)
		{
			this.renderManager = new RenderManager(stage);

			stage.removeChildren();
			stage.addChild(this);

//			renderManager.addLayer("back", "2D");
//			renderManager.addLayer("avatar", "3D");
			renderManager.addLayer("front", "2D");
			renderManager.addEventListener("layerCreated", renderManagerLayerCreated);
		}

		public function addService(obj:*):void
		{
			obj.initialize(this);
		}

		protected function renderManagerLayerCreated(event:Event):void
		{
			dispatchEvent(new Event("complete"));
		}

		public function changeScreen(clazz:Class):void
		{
			var self:* = this;
			var s:IScreen = new clazz;
			s.onInit(this, function():void
			{
				if (currentScreen)
				{
					currentScreen.dispose();
				}
				s.update2DLayer("front", renderManager.getLayerRoot("front"));

				currentScreen = s;
			})
		}

		public function showLoading():void
		{
			loadingScene = createView(defaultPackage, defaultLoadingName);
		}

		public function hideLoading():void
		{
			loadingScene.removeFromParent();
			loadingScene.dispose();
			loadingScene = null;
		}

		public function createView(packName:String, compName:String):GComponent
		{
			var gView:GComponent = UIPackage.createObject(packName, compName).asCom;
			gView.setSize(GRoot.inst.width, GRoot.inst.height);
			gView.addRelation(GRoot.inst, RelationType.Size);
			GRoot.inst.addChild(gView);
			if (loadingScene != null)
			{
				GRoot.inst.setChildIndex(loadingScene, GRoot.inst.numChildren - 1);
			}
			return gView;
		}

		public function setTransferParams(params:Array):void
		{
			this.params = params;
		}

		public function getTransferParams():Array
		{
			return this.params;
		}
	}
}
