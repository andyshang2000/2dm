package zz2d.ui.view
{
	import fairygui.GComponent;
	import fairygui.PackageItem;
	import fairygui.display.UISprite;

	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;

	import zzsdk.utils.FileUtil;

	public class Particle extends GComponent
	{
		private var _particleSystem:PDParticleSystem;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);

			setXY(0, 0);
//			.visible = false;

			if (getChild("texture").packageItem.loaded)
				__imageLoaded(packageItem);
			else
				getChild("texture").packageItem.owner.addItemCallback(getChild("texture").packageItem, __imageLoaded);
		}

		protected function __imageLoaded(pi:PackageItem):void
		{
			_particleSystem = new PDParticleSystem( //
				XML(FileUtil.open("particle.pex")), //
				getChild("texture").asImage.texture);

			// add it to the stage and the juggler
			Starling.juggler.add(_particleSystem);

			// start emitting particles
			_particleSystem.start();
			_particleSystem.emitterX = 320;
			_particleSystem.emitterY = 540;

			UISprite(displayObject).addChild(_particleSystem);
		}

		public function start():void
		{
		}
	}
}
