package zz2d.modules.makeup
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.OnCompleteRenderPlugin;

	import flash.geom.Point;

	import fairygui.Controller;
	import fairygui.GComponent;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.event.GTouchEvent;

	import zz2d.ui.util.GViewSupport;

	public class Tool extends GComponent
	{
		[G]
		public var tool:GObject;

		public var model:GComponent;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);

			GViewSupport.assign(this);

			tool.setXY(110, 2220);
			tool.touchable = false;
		}

		protected function onTouch(event:GTouchEvent):void
		{
			tool.setXY(event.stageX / GRoot.contentScaleFactor, event.stageY / GRoot.contentScaleFactor);
			//				toolBar.touchable = false;
			//				toolBar.scrollPane.isDragged = false;
			if (event.type == GTouchEvent.END)
			{
				hide();
				unuse(true);
			}
		}

		public function hide():void
		{
			tool.visible = false;
		}

		public function showTool():void
		{
			tool.visible = true;
		}

		public function useTool():void
		{
			GRoot.inst.addChild(tool);
			GRoot.inst.addEventListener(GTouchEvent.BEGIN, this.onTouch);
			GRoot.inst.addEventListener(GTouchEvent.DRAG, this.onTouch);
			GRoot.inst.addEventListener(GTouchEvent.END, this.onTouch);
			enabled = false;
		}

		public function unuse(anim:Boolean = false):void
		{
			addChild(tool);
			tool.setXY(0, 1120);
			GRoot.inst.removeEventListener(GTouchEvent.BEGIN, this.onTouch);
			GRoot.inst.removeEventListener(GTouchEvent.DRAG, this.onTouch);
			GRoot.inst.removeEventListener(GTouchEvent.END, this.onTouch);
			enabled = true;
		}

		public function setModel(model:GComponent):void
		{
			this.model = model;
		}

		public function updateOption(c:Controller, i:int):void
		{
		}
	}
}
