package view
{
	import component.CustomTextfield;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.CacheModel;
	import model.CheatModel;

	public class CheatWhitePanel extends Sprite
	{
		private var _top:Sprite;
		private var _content:Sprite;
		private var _topTxt:CustomTextfield;
		private var _contentTxt:CustomTextfield;
		private var _closeBlock:Sprite;
		private var _moveBlock:Sprite;
		private var _resizeBlock:Sprite;
		private var _tempX:Number;
		private var _tempY:Number;
		
		public function CheatWhitePanel()
		{
			_top = new Sprite();
			_top.graphics.beginFill(0x7e7d7b, 0.7);
			_top.graphics.drawRect(0, 0, 400, 30);
			_top.graphics.endFill();
			this.addChild(_top);
			
			_content = new Sprite();
			_content.graphics.beginFill(0x989896, 0.7);
			_content.graphics.drawRect(0, 0, 400, 30);
			_content.graphics.endFill();
			this.addChild(_content);
			
			_topTxt = new CustomTextfield(true, 3);
			_topTxt.color = 0x0fe693;
			_topTxt.wordWrap = true;
			_topTxt.multiline = true;
			_topTxt.leading = 2;
			_topTxt.selectable = true;
			this.addChild(_topTxt);
			
			_contentTxt = new CustomTextfield(true, 3);
			_contentTxt.color = 0xffd800;
			_contentTxt.wordWrap = true;
			_contentTxt.multiline = true;
			_contentTxt.leading = 2;
			_contentTxt.selectable = true;
			this.addChild(_contentTxt);
			
			_closeBlock = new Sprite();
			_closeBlock.graphics.beginFill(0x00ff72, 0.6);
			_closeBlock.graphics.drawRect(0, 0, 30, 30);
			_closeBlock.graphics.endFill();
			_closeBlock.buttonMode = true;
			this.addChild(_closeBlock);
			
			_moveBlock = new Sprite();
			_moveBlock.graphics.beginFill(0x009cff, 0.6);
			_moveBlock.graphics.drawRect(0, 0, 30, 30);
			_moveBlock.graphics.endFill();
			_moveBlock.buttonMode = true;
			this.addChild(_moveBlock);
			
			_resizeBlock = new Sprite();
			_resizeBlock.graphics.beginFill(0xffd800, 0.6);
			_resizeBlock.graphics.drawRect(0, 0, 30, 30);
			_resizeBlock.graphics.endFill();
			_resizeBlock.buttonMode = true;
			this.addChild(_resizeBlock);
			
			initView();
			
			addEvent();
		}
		
		private function initView():void
		{
			var cachePos:Point = CacheModel.getInstance().getData("pos") as Point;
			var cacheSize:Point = CacheModel.getInstance().getData("size") as Point;
			var bgWidth:Number = 250;
			var bgHeight:Number = 300;
			if (cachePos) {
				this.x = cachePos.x;
				this.y = cachePos.y;
			}
			if (cacheSize) {
				bgWidth = cacheSize.x;
				bgHeight = cacheSize.y;
			}
			
			_top.width = bgWidth;
			_top.height = 100;
			_content.width = bgWidth;
			_content.height = bgHeight - _top.height;
			_content.y = _top.height;
			_topTxt.x = _top.x + 5;
			_topTxt.y = _top.y + 5;
			_topTxt.width = _top.width - 10;
			_topTxt.height = _top.height - 10;
			_contentTxt.x = _content.x + 5;
			_contentTxt.y = _content.y + 5;
			_contentTxt.width = _content.width - 10;
			_contentTxt.height = _content.height - 10;
			_closeBlock.x = _content.width - _closeBlock.width;
			_closeBlock.y = 0;
			_moveBlock.x = _content.width - _moveBlock.width;
			_moveBlock.y = (_content.y +_content.height - _moveBlock.height) >> 1;
			_resizeBlock.x =_content.width - _resizeBlock.width;
			_resizeBlock.y = _content.y + _content.height - _resizeBlock.height;
		}
		
		private function addEvent():void
		{
			_closeBlock.addEventListener(MouseEvent.CLICK, closeHandler);
			_moveBlock.addEventListener(MouseEvent.MOUSE_DOWN, moveDownHandler);
			_resizeBlock.addEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler);
		}
		
		protected function closeHandler(event:MouseEvent):void
		{
			CheatModel.getInstance().dispatchEvent(new Event(CheatModel.CLOSE_PANEL));
		}
		
		protected function moveDownHandler(event:MouseEvent):void
		{
			_moveBlock.removeEventListener(MouseEvent.MOUSE_DOWN, moveDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, moveUpHandler);
			
			this.alpha = 0.4;
			_tempX = this.parent.mouseX;
			_tempY = this.parent.mouseY;
		}
		
		protected function moveMoveHandler(event:MouseEvent):void
		{
			var dx:Number = this.parent.mouseX - _tempX;
			var dy:Number = this.parent.mouseY - _tempY;
			this.x += dx;
			this.y += dy;
			
			_tempX = this.parent.mouseX;
			_tempY = this.parent.mouseY;
		}
		
		protected function moveUpHandler(event:MouseEvent):void
		{
			_moveBlock.addEventListener(MouseEvent.MOUSE_DOWN, moveDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, moveUpHandler);
			
			this.alpha = 1;
			var pos:Point = new Point(this.x, this.y);
			CacheModel.getInstance().saveData("pos", pos);
		}
		
		protected function resizeDownHandler(event:MouseEvent):void
		{
			_resizeBlock.removeEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			
			this.alpha = 0.4;
			_tempX = this.parent.mouseX;
			_tempY = this.parent.mouseY;
		}
		
		protected function resizeMoveHandler(event:MouseEvent):void
		{
			var dx:Number = this.parent.mouseX - _tempX;
			var dy:Number = this.parent.mouseY - _tempY;
			_content.width += dx;
			_content.height += dy;
			setPos();
			
			_tempX = this.parent.mouseX;
			_tempY = this.parent.mouseY;
		}
		
		protected function resizeUpHandler(event:MouseEvent):void
		{
			_resizeBlock.addEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			
			this.alpha = 1;
			var pos:Point = new Point(this.width, this.height);
			CacheModel.getInstance().saveData("size", pos);
		}
		
		/**
		 * 设置位置
		 */
		private function setPos():void
		{
			_top.width = _content.width;
			_contentTxt.width = _content.width - 10;
			_contentTxt.height = _content.height - 10;
			_topTxt.width = _contentTxt.width;
			_closeBlock.x = _content.width - _closeBlock.width;
			_moveBlock.x = _content.width - _moveBlock.width;
			_moveBlock.y = (_content.y +_content.height - _moveBlock.height) >> 1;
			_resizeBlock.x =_content.width - _resizeBlock.width;
			_resizeBlock.y = _content.y + _content.height - _resizeBlock.height;
		}
		
		public function setData(content:String):void
		{
			_contentTxt.htmlText = content;
			_contentTxt.scrollV = 1;
		}
		
		public function setTop(content:String):void
		{
			_topTxt.htmlText = content;
			_topTxt.scrollV = 1;
		}
	}
}