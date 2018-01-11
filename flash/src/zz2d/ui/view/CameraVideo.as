package zz2d.ui.view
{
	import flash.display.BitmapData;
	import flash.display3D.textures.VideoTexture;
	import flash.geom.Matrix;
	import flash.media.Camera;

	import starling.core.Starling;
	import starling.display.Quad;
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

		public function CameraVideo(width:Number, height:Number)
		{
			w = width;
			h = height;
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
			super.pixelMask = quad;
		}

		public function attachCamera(camera:Camera, direct:int = 1):void
		{
			if (camera == null)
			{
				if(texture)
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
			camera.setMode(h, w, 24);

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
					image = new Quad(texture.width, texture.height);
					image.texture = texture;
//					image.scaleX = 0.3333;
//					image.scaleY = 0.3333;
					image.rotation = -Math.PI / 2;
					image.y = texture.width; // / 3;
				}
				addChild(image);
			});
			texture.onRestore = function():void
			{
				texture.root.attachVideo("Camera", camera);
			};
			resume();
		}

		public function snap():void
		{
			if (image)
			{
				if (!rt)
				{
					rt = new RenderTexture(image.texture.width, image.texture.height);
				}
				image.rotation = 0;
				image.y = 0
				rt.draw(image);
				image.rotation = -Math.PI / 2;
				image.y = rt.width; // / 3;
				image.texture = rt;
			}
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
