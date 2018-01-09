package zz2d.ui.view
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.media.Camera;

	import starling.display.Image;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;

	public class CameraVideo extends PixelMaskDisplayObject
	{
		private var camera:Camera;
		private var image:Image;

		private var bitmapData:BitmapData;
		private var _offsets:Array = [0, 0];
		private var w:Number;
		private var h:Number;
		private var skip:Boolean;
		private var matrix:Matrix = new Matrix;
		private var videoTexture:Texture;

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
			super.pixelMask = new Image(texture);
		}

		public function attachCamera(camera:Camera, direct:int = 1):void
		{
			if (camera == null)
				return;

			if (direct == 1)
			{
				//IOS style
				matrix.identity()
				matrix.rotate(Math.PI / 2);
				matrix.scale(1, -1);
				matrix.translate(w, h);
			}
			else
			{
				//android style
				matrix.identity();
				matrix.rotate(Math.PI / 2);
				matrix.translate(w, 0);
			}
			this.camera = camera;
			camera.setMode(h, w, 24);
			videoTexture = Texture.fromCamera(camera, 1, function():void
			{
				if (!image)
				{
					addChild(image = new Image(videoTexture));
				}
			});
			resume();
		}
	}
}
