package zz2d.modules.makeup
{
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fairygui.GComponent;
	import fairygui.GGraph;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.event.GTouchEvent;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.textures.RenderTexture;

	public class PaintingTool extends Tool
	{
		private var source:DisplayObject;
		private var rt:RenderTexture;
		private static var rtTemp:RenderTexture;
		private static var rtTempQuad:Quad;
		private var toolMask:GObject;
		private var p:Point = new Point;
		private var sourceRect:Rectangle;

		private var pList:Array = [];
		private var paintArea:GGraph;
		private var drawed:Boolean = false;
		private var maskTexture:RenderTexture;
		private var maskQuad:Quad;
		private var maskTextures:Vector.<RenderTexture> = new Vector.<RenderTexture>;
		private var maskQuads:Vector.<Quad> = new Vector.<Quad>;
		private var sourceIndex:Array = [];
		private var offsetY:int = 0;
		private var offsetX:int = 0;

		BlendMode.register("MASK_MODE_NORMAL", Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA);

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			paintArea = new GGraph;
			paintArea.drawEllipse(1, 0, 0, 0xFFFFFF, 1);
			paintArea.setSize(45, 45);
			try
			{
				toolMask = GComponent(tool).getChild("toolMask");
			}
			catch (err:Error)
			{
			}
		}

		override protected function onTouch(event:GTouchEvent):void
		{
			super.onTouch(event);
			var source:*;
			var i:int = 0;
//			hide();
			tool.setXY(event.stageX / GRoot.contentScaleFactor, event.stageY / GRoot.contentScaleFactor);
			if (rt && maskTexture)
			{
				toolMask.localToRoot(0, 0, p);
				model.rootToLocal(p.x, p.y, p);
				var matrix:Matrix = null;
//				new Matrix;
				if (validatePos(p))
				{
					drawed = true;
					pList.push(p.clone());
					var sf:Number = GRoot.contentScaleFactor;
					var ginst:* = GRoot.inst
					paintArea.setXY((p.x - offsetX), (p.y - offsetY));
					maskTexture.draw(paintArea.displayObject);
					rt.clear(0x0, 0);
					for (i = 0; i < sourceIndex.length; i++)
					{
						source = sourceIndex[i]
						rtTemp.clear();
						rtTemp.draw(source.displayObject, matrix);
						rtTemp.draw(maskQuads[i], matrix);
						rt.draw(rtTempQuad);
					}
				}

				if (event.type == GTouchEvent.END)
				{
					rt.clear(0x0, 0);
//					rt.draw(source);
//					rt.draw(maskQuad);
					for (i = 0; i < sourceIndex.length; i++)
					{
						source = sourceIndex[i]
						rtTemp.clear();
						rtTemp.draw(source.displayObject, matrix);
						rtTemp.draw(maskQuads[i], matrix);
						rt.draw(rtTempQuad);
					}
					if (drawed)
					{
						pList = [];
					}
				}
			}
		}

		private function validatePos(p:Point):Boolean
		{
			return true;
			if (!sourceRect.contains(p.x, p.y))
				return false;
			for each (var po:Point in pList)
			{
				if (Point.distance(p, po) < 10)
				{
					return false;
				}
			}

			return true;
		}

		public function setRenderTexture(rt:RenderTexture, offsetX:int = 0, offsetY:int = 0):void
		{
			this.rt = rt;
			if (!rtTemp)
			{
				rtTemp = new RenderTexture(rt.width, rt.height, true);
				rtTempQuad = new Quad(rt.width, rt.height);
				rtTempQuad.texture = rtTemp;
			}
			this.offsetX = offsetX;
			this.offsetY = offsetY;

//			DisplayObjectContainer(model.displayObject).addChild(maskQuad);
			"MASK_MODE_NORMAL";
		}

		public function setRenderSource(source:GObject):void
		{
			var maskTexture:RenderTexture;
			var maskQuad:Quad;
			this.source = source.displayObject;
			if (maskTextures.length <= 8)
			{
				maskTexture = new RenderTexture(rt.width, rt.height, true, -1);
				maskQuad = new Quad(rt.width, rt.height);
				maskQuad.readjustSize();
				maskQuad.blendMode = BlendMode.MASK;
				maskQuad.texture = maskTexture;
			}
			else
			{
				maskTexture = maskTextures.shift();
				maskQuad = maskQuads.shift();
				maskQuad.texture = maskTexture;
				maskTexture.clear();
			}
			this.maskTexture = maskTexture;
			maskTextures.push(maskTexture);
			maskQuads.push(maskQuad);

			sourceIndex.push(source);
			if (sourceIndex.length > 8)
			{
				sourceIndex.shift();
			}
		}

		public function setRenderSourceRect(x:Number, y:Number, width:Number, height:Number):void
		{
			sourceRect = new Rectangle(x - 50, y - 40, width + 100, height + 80);
		}
	}
}
