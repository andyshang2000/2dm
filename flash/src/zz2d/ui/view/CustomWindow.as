package zz2d.ui.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import fairygui.GRoot;
	import fairygui.Window;

	public class CustomWindow extends Window
	{

		override protected function doShowAnimation():void
		{
			super.doShowAnimation();
			return;
			var scaleX:Number = contentPane.scaleX;
			var scaleY:Number = contentPane.scaleY;
			var x:Number = contentPane.x;
			var y:Number = contentPane.y;
			contentPane.scaleX *= 0.5;
			contentPane.scaleY *= 0.5;
			contentPane.x = (GRoot.inst.width - contentPane.initWidth * contentPane.scaleX) / 2;
			contentPane.y = (GRoot.inst.height - contentPane.initHeight * contentPane.scaleY) / 2;
			x = Math.max(x, 0);
			y = Math.max(y, 0);
			TweenLite.to(contentPane, 0.5, {x: x, y: y, scaleX: scaleX, scaleY: scaleY, ease: Back.easeOut, onComplete: onShown});
			modal = true;
		}

		override protected function doHideAnimation():void
		{
			super.doHideAnimation();
			return;
			var scaleX:Number = contentPane.scaleX;
			var scaleY:Number = contentPane.scaleY;
			var x:int = (GRoot.inst.width - contentPane.initWidth * 0.2) / 2;
			var y:int = (GRoot.inst.height - contentPane.initHeight * 0.2) / 2;
			TweenLite.to(contentPane, 0.5, {x: x, y: y, scaleX: .2, scaleY: .2, ease: Back.easeIn, onComplete: hideImmediately});
		}
	}
}
