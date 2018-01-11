package zz2d.ui.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import fairygui.GRoot;
	import fairygui.Window;

	public class CustomWindow extends Window
	{

		private var startX:int;
		private var startY:int;
		private var startScaleX:Number = 0.2;
		private var startScaleY:Number = 0.2;

		override protected function doShowAnimation():void
		{
			var scaleX:Number = contentPane.scaleX;
			var scaleY:Number = contentPane.scaleY;
			var x:Number = contentPane.x;
			var y:Number = contentPane.y;
			startX = x;
			startY = y;
			contentPane.scaleX *= 0.5;
			contentPane.scaleY *= 0.5;
			if (scaleX == 1)
			{
				contentPane.x = Math.max((GRoot.inst.width - contentPane.initWidth) / 2, 0);
				contentPane.y = Math.max((GRoot.inst.height - contentPane.initHeight) / 2, 0);
				startX = contentPane.x;
				startY = contentPane.y;
				startScaleX = contentPane.scaleX;
				startScaleY = contentPane.scaleY;
			}
			x = Math.max(x, 0);
			y = Math.max(y, 0);
			TweenLite.to(contentPane, 0.3, {x: x, y: y, scaleX: scaleX, scaleY: scaleY, ease: Back.easeOut, onComplete: onShown});
			modal = true;
		}

		override protected function doHideAnimation():void
		{
			var x:int = contentPane.x;
			var y:int = contentPane.y;
			var scaleX:Number = contentPane.scaleX;
			var scaleY:Number = contentPane.scaleY;
			TweenLite.to(contentPane, 0.3, {x: startX, y: startY, scaleX: startScaleX, scaleY: startScaleY, ease: Back.easeIn, onComplete: function():void
			{
				contentPane.x = x;
				contentPane.y = y;
				contentPane.scaleX = scaleX;
				contentPane.scaleY = scaleY;
				hideImmediately();
			}});
		}
	}
}
