package view
{
	import component.CustomTextfield;
	
	import events.ParamEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getQualifiedClassName;
	
	import model.CheatModel;

	public class CheatWhiteBtn extends Sprite
	{
		protected static const GLOW:GlowFilter = new GlowFilter(0xffd800,1,3,3,3,3);
		public var data:*;
		private var _model:CheatModel;
		private var _bg:Sprite;
		private var _move:Sprite;
		private var _name:CustomTextfield;
		private var _selected:Boolean;
		private var _onMove:Boolean;

		public function get onMove():Boolean
		{
			return _onMove;
		}

		public function set onMove(value:Boolean):void
		{
			_onMove = value;
			_bg.graphics.clear();
			if (_onMove) {
				_bg.graphics.beginFill(0xff5e7c, 0.6);
			} else {
				_bg.graphics.beginFill(0xf1efef, 0.6);
			}
			_bg.graphics.drawRect(0, 0, 80, 30);
			_bg.graphics.endFill();
			_bg.width = _name.width + 10;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if (_selected) {
				_bg.filters = [GLOW];
				_move.filters = [GLOW];
			} else {
				_bg.filters = [];
				_move.filters = [];
			}
		}
		
		public function CheatWhiteBtn()
		{
			_model = CheatModel.getInstance();
			
			_bg = new Sprite();
			_bg.buttonMode = true;
			_bg.graphics.beginFill(0xf1efef, 0.6);
			_bg.graphics.drawRect(0, 0, 80, 30);
			_bg.graphics.endFill();
			this.addChild(_bg);

			_move = new Sprite();
			_move.buttonMode = true;
			_move.graphics.beginFill(0x00ff72, 0.6);
			_move.graphics.drawRect(0, 0, 15, 15);
			_move.graphics.endFill();
			_move.y = _bg.height;
			this.addChild(_move);
			
			_name = new CustomTextfield(true, 3);
			_name.mouseEnabled = false;
			_name.color = 0xffd800;
			_name.align = "center";
			_name.x = 5;
			_name.y = 5;
			this.addChild(_name);
			
			addEvent();
		}
		
		private function addEvent():void
		{
			_bg.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_bg.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_bg.addEventListener(MouseEvent.CLICK, displayHandler);
			_move.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_move.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_move.addEventListener(MouseEvent.CLICK, moveHandler);
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			if (data == null || !(data is DisplayObject)) {
				return ;
			}
			event.currentTarget.filters = [GLOW];
			_model.dispatchEvent(new ParamEvent(CheatModel.SHOW_OBJECT, {isShow:true, data:data}));
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			if (data == null || !(data is DisplayObject)) {
				return ;
			}
			if (selected == false) {
				event.currentTarget.filters = [];
			}
			_model.dispatchEvent(new ParamEvent(CheatModel.SHOW_OBJECT, {isShow:false, data:data}));
		}
		
		private function displayHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			this.dispatchEvent(new ParamEvent(CheatModel.DISPLAY_ITEM));
		}
		
		private function moveHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			this.dispatchEvent(new ParamEvent(CheatModel.MOVE_ITEM));
		}
		
		public function setData(obj:*):void
		{
			data = obj;
			var arr:Array = getQualifiedClassName(data).split("::");
			if (arr.length > 1) {
				_name.text = arr[1];
			} else {
				_name.text = arr[0];
			}
			_name.width = _name.textWidth + 5;
			_bg.width = _name.width + 10;
			_move.width = _bg.width;
		}
	}
}