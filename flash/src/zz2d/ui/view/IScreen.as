package zz2d.ui.view
{
	
	import starling.display.Sprite;

	public interface IScreen
	{
		function dispose():void;
		function update2DLayer(name:String, root:Sprite):void;
		function onInit(screenMgr:ScreenManager, callback:Function):void;
	}
}
