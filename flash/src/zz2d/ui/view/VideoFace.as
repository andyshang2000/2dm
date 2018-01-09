package zz2d.ui.view
{
	import flash.media.Camera;
	
	import fairygui.GComponent;
	import fairygui.PackageItem;

	public class VideoFace extends GComponent
	{
		private var video:CameraVideo;
		public function VideoFace()
		{
			super();
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			setXY(0, 0);
			//			.visible = false;
			
			if (getChild("pixelMask").packageItem.loaded)
				__imageLoaded(packageItem);
			else
				getChild("pixelMask").packageItem.owner.addItemCallback(getChild("pixelMask").packageItem, __imageLoaded);
		}
		
		private function __imageLoaded(packageItem:PackageItem):void
		{
			video = CameraVideo.createWithMask(getChild("pixelMask").asImage.texture);
			displayListContainer.addChild(video);
			
			video.attachCamera(Camera.getCamera(), 2);
		}
	}
}
