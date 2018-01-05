package zz2d.services
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import zz2d.ui.IRenderManager;
	import zz2d.ui.view.ScreenManager;

	public class ScreenShot
	{
		private static var _inst:ScreenShot;
		private var renderMgr:IRenderManager;
		
		public static function get inst():ScreenShot
		{
			if(_inst)
				return _inst;
			_inst = new ScreenShot;
			return _inst;
		}
		
		public function initialize(obj:ScreenManager):void
		{
			this.renderMgr = obj.renderManager;
		}
		
		public static function draw(bitmap:BitmapData, //
									rect:Rectangle = null, //
									filter:Array = null, //
									callback:Function = null):void
		{
			inst.renderMgr.drawTo(bitmap, rect, filter);
			inst.renderMgr.addEventListener("snap", function():void
			{
				inst.renderMgr.removeEventListener("snap", arguments.callee);
				callback();
			});
		}
	}
}