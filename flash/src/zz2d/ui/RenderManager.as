package zz2d.ui
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	import zzsdk.display.Screen;

	[Event(name = "layerCreated", type = "flash.events.Event")]
	public class RenderManager extends EventDispatcher implements IRenderManager
	{
		private var stage:Stage;
		private var renderOrder:Array = [];
		private var bootQueue:Array = [];
		private var layerRequest:int = 0;

		private var bufferBitmapData:BitmapData;
		private var outputBitmapData:BitmapData;
		private var drawScheduled:Boolean;
		private var targetRect:Rectangle;

		public function RenderManager(stage:Stage)
		{
			this.stage = stage;
			Screen.designW = 480;
			Screen.designH = 800;
			Screen.initialize(stage);
			
			//
			stage.color = 0;
		}

		public function drawTo(bitmap:BitmapData, rect:Rectangle = null, filter:Array = null):void
		{
			outputBitmapData = bitmap;
			targetRect = rect;
			if (targetRect == null)
				targetRect = bitmap.rect;
			drawScheduled = true;
		}

//		protected function firstRenderEvent(event:Event):void
//		{
//			removeEventListener(Scene3D.RENDER_EVENT, firstRenderEvent);
//			addEventListener(Scene3D.RENDER_EVENT, renderEvent);
//			while (bootQueue.length > 0)
//			{
//				var obj:Object = bootQueue.shift();
//				var f:Function = obj.callee;
//				f.apply(null, obj);
//			}
//
//			bufferBitmapData = new BitmapData(context.backBufferWidth, //
//				context.backBufferHeight, //
//				false, 0x0);
//		}

		public function addLayer(name:String, type:String):void
		{
			trace("add layer:" + name + ", type:" + type);
			//
			layerRequest++;
			//
			if (type.toUpperCase() == "2D")
			{
				var layer:Starling = new Starling(StarlingLayer, stage, Screen.fullscreenPort, null, Context3DRenderMode.AUTO);
//				layer.stage.stageWidth = Screen.designW;
//				layer.stage.stageHeight = Screen.designH;
				layer.antiAliasing = 2;
				layer.start();
				layer.simulateMultitouch = true;
				renderOrder.push(layer);
				layer.addEventListener("rootCreated", function():void
				{
					layer.addEventListener("rootCreated", arguments.callee);
					layer.root.name = name;
					updateLayerRequest();
				});
			}
			else
			{
			}
		}

		private function updateLayerRequest():void
		{
			layerRequest--;
			if (layerRequest == 0)
			{
				dispatchEvent(new Event("layerCreated"));
			}
		}

		public function getLayerRoot(name:String):*
		{
			for (var i:int = 0; i < renderOrder.length; i++)
			{
				var layer:* = renderOrder[i] as Starling;
				if (layer && layer.root && layer.root.name == name)
				{
					return layer.root;
				}
			}
		}
	}
}
import starling.display.Sprite;

class StarlingLayer extends Sprite
{
}
