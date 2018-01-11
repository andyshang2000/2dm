package zz2d.game
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	import fairygui.GRoot;

	import zz2d.util.DataUtil;

	public class Game
	{
		public static var money:Money = new Money;
		public static var inventory:Inventory;
		public static var signRecord:SignRecord = new SignRecord;
		public static var buyConfirm:Boolean = true;
		public static var noVideo:Boolean;
		public static var intersLimit:int;

		public static var sfxMute:Boolean = false;
		public static var musicMute:Boolean = false;

		public static function save():void
		{
			money.save();
			inventory.save();
			signRecord.save();
			DataUtil.writeBool("buyc", buyConfirm);
			DataUtil.writeBool("sfxMute", sfxMute);
			DataUtil.writeBool("muiscMute", musicMute);
		}

		public static function load():void
		{
			DataUtil.id = "zz2d18011115";
			DataUtil.load(DataUtil.id);
			if (!inventory)
				inventory = new Inventory;
			money.load();
			inventory.load();
			signRecord.load();

			buyConfirm = DataUtil.readBool("buyc");
			sfxMute = DataUtil.readBool("sfxMute");
			musicMute = DataUtil.readBool("musicMute");

			if (sfxMute)
				GRoot.inst.volumeScale = 0;
			if (musicMute)
				GRoot.inst.bgmVolumeScale = 0;
		}

		public static function listen(extContext:ExtensionContext):void
		{
			extContext.addEventListener(StatusEvent.STATUS, new Game().onDataReceived);
		}

		private function onDataReceived(event:StatusEvent):void
		{
			switch (event.code)
			{
				case "onAdClosed":
					if (!Game.sfxMute)
						GRoot.inst.volumeScale = 1;
					if (!Game.musicMute)
						GRoot.inst.bgmVolumeScale = 1;
					break;
				case "inters":
					Game.intersLimit = int(event.level);
					break;
				case "videoLoaded":
					Game.noVideo = false;
					break;
				case "videoFailedToLoad":
					Game.noVideo = true;
					break;
				case "reward":
					Game.money.m1 += 100;
					Game.money.save();
					break;
			}
		}
	}
}
