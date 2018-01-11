package zz2d.ui.view
{
	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GRoot;

	import zz2d.game.Game;
	import zz2d.ui.util.GViewSupport;

	public class SoundSettings extends GComponent
	{
		[G]
		public var sfx:GButton;
		[G]
		public var music:GButton;

		[Handler(clickGTouch)]
		public function sfxClick():void
		{
			if (sfx.selected)
			{
				Game.sfxMute = true;
				Game.save();
				GRoot.inst.volumeScale = 0;
			}
			else
			{
				Game.sfxMute = false;
				Game.save();
				GRoot.inst.volumeScale = 1;
			}
		}

		[Handler(clickGTouch)]
		public function musicClick():void
		{
			if (music.selected)
			{
				Game.musicMute = true;
				Game.save();
				GRoot.inst.bgmVolumeScale = 0;
			}
			else
			{
				Game.musicMute = false;
				Game.save();
				GRoot.inst.bgmVolumeScale = 1;
			}
		}

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			sfx.selected = Game.sfxMute;
			music.selected = Game.musicMute;
		}
	}
}
