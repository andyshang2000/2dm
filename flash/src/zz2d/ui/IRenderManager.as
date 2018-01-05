package zz2d.ui
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	public interface IRenderManager extends IEventDispatcher
	{
		function drawTo(bitmap:BitmapData, rect:Rectangle = null, filter:Array = null):void;
	}
}
