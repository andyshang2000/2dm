package zz2d.ui.view
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.media.Camera;
	
	import fairygui.GRoot;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.ConcreteVideoTexture;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class CameraVideo extends PixelMaskDisplayObject
	{
		private var camera:Camera;
		private var image:Quad;

		private var bitmapData:BitmapData;
		private var _offsets:Array = [0, 0];
		private var w:Number;
		private var h:Number;
		private var skip:Boolean;
		private var matrix:Matrix = new Matrix;
		private var texture:ConcreteVideoTexture;
		private var disposed:Boolean;

		private var rt:RenderTexture;

		private var imageContainer:Sprite;
		private var maskTexture:Texture;
		private var direct:int;
		private var snapImage:Quad;

		public function CameraVideo(width:Number, height:Number)
		{
			w = width;
			h = w * GRoot.inst.actualHeight / GRoot.inst.actualWidth;
			imageContainer = new Sprite;
		}

		public static function createWithMask(texture:Texture, source:* = null):CameraVideo
		{
			var res:CameraVideo = new CameraVideo(texture.width, texture.height);
			res.setMask(texture);
			if (source is Camera)
			{
				res.attachCamera(source);
			}
			return res;
		}

		public function pause():void
		{
//			video.attachCamera(null);
//			Texture.fromCamera(
		}

		public function resume():void
		{
		}

		public function setMask(texture:Texture):void
		{
			var quad:Quad = new Quad(texture.width, texture.height);
			quad.texture = texture;
			maskTexture = texture
			super.pixelMask = quad;
		}

		public function attachCamera(camera:Camera, direct:int = 1):void
		{
			this.direct = direct;
			if (camera == null)
			{
				if (texture)
				{
					texture.dispose();
					texture = null;
				}
				if (image)
				{
					image.removeFromParent(true);
					image = null;
					disposed = true;
				}
				return;
			}
			disposed = false;
			this.camera = camera;
			camera.setMode(h / 2, w / 2, 24);

			if (!texture)
			{
				texture = new ConcreteVideoTexture(Starling.context.createVideoTexture(), scale);
			}
			texture.attachVideo("Camera", camera, function():void
			{
				if (disposed)
					return;
				if (!image)
				{
					imageContainer = new Sprite;
					image = new Quad(texture.width, texture.height);
					image.texture = texture;
//					image.scaleX = 0.3333;
//					image.scaleY = 0.3333;

					addChild(imageContainer);
				}
				image.pivotX = image.texture.width / 2;
				image.pivotY = image.texture.height / 2;
				image.rotation = -Math.PI / 2;
				if (direct == 1)
					image.scaleX = -1;
				else if (direct == 2)
					image.scaleX = 1;
				imageContainer.addChild(image);
				imageContainer.x = maskTexture.width / 2;
				imageContainer.y = maskTexture.height / 2;
				imageContainer.scaleX = -1;
				if(snapImage)
				{
					snapImage.visible = false;
				}
				image.visible = true;
			});
			texture.onRestore = function():void
			{
				texture.root.attachVideo("Camera", camera);
			};
			resume();
		}

		public function snap():void
		{
			if (!rt)
			{
				rt = new RenderTexture(image.texture.width, image.texture.height);
				snapImage = new Quad(image.texture.width, image.texture.height);
				snapImage.texture = rt;
				snapImage.pivotX = image.texture.width / 2;
				snapImage.pivotY = image.texture.height / 2;
				snapImage.rotation = -Math.PI / 2;
				imageContainer.addChild(snapImage);
			}
			image.rotation = 0;
			image.pivotX = 0;
			image.pivotY = 0;
			image.scaleX = 1;
			rt.draw(image);
			snapImage.visible = true;
			image.visible = false;
			if (direct == 1)
				snapImage.scaleX = -1;
			else if (direct == 2)
				snapImage.scaleX = 1;
		}

		override public function dispose():void
		{
			super.dispose();
			if (rt)
				rt.dispose();
			if (texture)
				try
				{
					texture.dispose();
				}
				catch (error:Error)
				{
				}
			if (image && image.parent)
				image.removeFromParent(true);
			image = null;
			rt = null;
			texture = null;
		}
	}
}
