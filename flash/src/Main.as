package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	import fairygui.UIObjectFactory;
	
	import zz2d.services.ScreenShot;
	import zz2d.services.ShareService;
	import zz2d.ui.view.EnterScreen;
	import zz2d.ui.view.Particle;
	import zz2d.ui.view.Particle2;
	import zz2d.ui.view.ScreenManager;

	[SWF(backgroundColor = "0x0", frameRate="60")]
	public class Main extends MovieClip
	{
		public function Main()
		{
			
			UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Particle", Particle);
			UIObjectFactory.setPackageItemExtension("ui://zz2d.dressup.gui/Particle2", Particle2);
			
			var stage:Stage = this.stage;
			var screenMgr:ScreenManager = new ScreenManager(stage);
			screenMgr.addService(ScreenShot.inst);
			screenMgr.addService(ShareService.inst);
			screenMgr.addEventListener(Event.COMPLETE, function():void
			{
				screenMgr.changeScreen(EnterScreen);
			});
		}
	}
}
