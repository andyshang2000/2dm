package zz2d.ui.view
{
	import fairygui.PackageItem;
	import fairygui.display.UISprite;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	import zzsdk.utils.FileUtil;

	public class Particle2 extends Particle
	{
		private var _particleSystem:PDParticleSystem;

		override protected function __imageLoaded(pi:PackageItem):void
		{
			_particleSystem = new PDParticleSystem( //
				XML(FileUtil.open("star.pex")), //
				getChild("texture").asImage.texture);

			// add it to the stage and the juggler

			// start emitting particles
		}

		override public function start():void
		{
			_particleSystem.start();
			_particleSystem.emitterX = 240;
			_particleSystem.emitterY = 800;
			Starling.juggler.add(_particleSystem);
			addEventListener(Event.ENTER_FRAME, updatePdp);
			UISprite(displayObject).addChild(_particleSystem);
		}

		private function updatePdp(event:Event):void
		{
			_particleSystem.emitterY -= 20.5 //* Starling.current.juggler.elapsedTime;
			if (_particleSystem.emitterY < -2250)
			{
				removeEventListener(Event.ENTER_FRAME, updatePdp);
				UISprite(displayObject).removeChild(_particleSystem);
				_particleSystem.stop(true);
			}
		}
	}
}
