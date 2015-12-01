package controller
{
	import events.ParamEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	import model.CheatModel;
	
	import view.CheatWhiteBtn;
	import view.CheatWhitePanel;

	public class CheatController extends Sprite
	{
		private static var _instance:CheatController;
		private var _model:CheatModel;
		
		private var _keyBoardList:Array = [];
		private var paramPanel:Sprite;   // 参数面板
		private var paramArray:Array;    // 参数数组
		private var redRectangle:Sprite;   // 红色选中框
		private var attributeArray:Array;  // 属性数组
		private var selectedItem:*;           // 选中的元件
		private var onMove:int = 0;    // 移动状态，0未选中(非右键)，1选中(右键)，2移动中
		private var originalX:Number = 0;    // 移动前x
		private var originalY:Number = 0;    // 移动前y
		private var resultPanel:CheatWhitePanel;      // 结果面板
		
		public function CheatController()
		{
			_model = CheatModel.getInstance();
			
			addEvent();
		}
		
		public static function getInstance():CheatController
		{
			if (_instance == null) {
				_instance = new CheatController();
			}
			return _instance;
		}
		
		private function addEvent():void
		{
			_model.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			_model.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			_model.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDown);
			_model.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardUp);
			_model.addEventListener(CheatModel.SHOW_OBJECT, showObject);
			_model.addEventListener(CheatModel.CLOSE_PANEL, closePanel);
		}
		
		private function stageMouseDown(event:MouseEvent):void
		{
			// 秘籍获取点击obj的各种参数
			if (event.altKey == true) {
				getParam(event.target);
				return ;
			}
			
			originalX = this.mouseX;
			originalY = this.mouseY;
			// 点击停止
			if (onMove == 2) {
				onMove = 0;
				selectedItem.onMove = false;
				selectedItem.dispatchEvent(new ParamEvent(CheatModel.DISPLAY_ITEM));
			}
			// 点击移动
			if (onMove == 1) {
				onMove = 2;
			}
		}
		
		private function stageMouseMove(event:MouseEvent):void
		{
			if (onMove == 2 && selectedItem && selectedItem.data) {
				selectedItem.data.x += this.mouseX - originalX;
				selectedItem.data.y += this.mouseY - originalY;
				originalX = this.mouseX;
				originalY = this.mouseY;
			}
		}
		
		private function keyboardDown(e:KeyboardEvent):void
		{
			if (onMove != 1 || selectedItem == null) {
				return ;
			}
			if (isKeyBoardDown(e.keyCode) == false) {
				_keyBoardList.push(e.keyCode);
			}
			if (isKeyBoardDown(38) || isKeyBoardDown(40) || isKeyBoardDown(37) || isKeyBoardDown(39)) {
				e.stopImmediatePropagation();
				var x_off:Number=0;
				var y_off:Number=0;
				if ((isKeyBoardDown(39)) && (isKeyBoardDown(37))) {
					x_off=0;
				} else if (isKeyBoardDown(39)) {
					if (e.shiftKey) {
						x_off=10;
					} else {
						x_off=1;
					}
				} else if (isKeyBoardDown(37)) {
					if (e.shiftKey) {
						x_off=-10;
					} else {
						x_off=-1;
					}
				}
				if ((isKeyBoardDown(38)) && (isKeyBoardDown(40))) {
					y_off=0;
				} else if (isKeyBoardDown(38)) {
					if (e.shiftKey) {
						y_off=-10;
					} else {
						y_off=-1;
					}
				} else if (isKeyBoardDown(40)) {
					if (e.shiftKey) {
						y_off=10;
					} else {
						y_off=1;
					}
				}
				if (y_off != 0 || x_off != 0) {
					selectedItem.data.x += x_off;
					selectedItem.data.y += y_off;
				}
			}
			if (isKeyBoardDown(Keyboard.ENTER)) {
				onMove = 0;
				selectedItem.onMove = false;
				selectedItem.dispatchEvent(new ParamEvent(CheatModel.DISPLAY_ITEM));
			}
		}
		
		private function keyboardUp(e:KeyboardEvent):void
		{
			if (isKeyBoardDown(e.keyCode)) {
				_keyBoardList.splice(_keyBoardList.indexOf(e.keyCode),1);
			}
		}
		
		/**
		 *判断是否按下某个键 
		 */		
		private function isKeyBoardDown(key:int):Boolean
		{
			return _keyBoardList.indexOf(key) > -1;
		}
		
		/**
		 * 关闭参数面板
		 */
		private function closePanel(event:Event):void
		{
			var item:CheatWhiteBtn;
			for each (item in paramArray) {
				item.selected = false;
				item.onMove = false;
			}
			selectedItem = null;
			onMove = 0;
			if (resultPanel && resultPanel.parent) {
				resultPanel.parent.removeChild(resultPanel);
			}
			if (paramPanel && paramPanel.parent) {
				paramPanel.parent.removeChild(paramPanel);
			}
		}
		
		/**
		 * 选中元件，准备移动
		 */
		protected function moveObjcet(event:ParamEvent):void
		{
			var item:CheatWhiteBtn;
			for each (item in paramArray) {
				item.selected = false;
				item.onMove = false;
			}
			selectedItem = event.currentTarget as CheatWhiteBtn;
			selectedItem.onMove = true;
			onMove = 1;
			_model.stage.focus = _model.stage;
		}
		
		/**
		 * 秘籍获取点击obj的各种参数
		 */
		private function getParam(e:*):void
		{
			var objArray:Array = [];
			while (e && e != _model.stage) {
				objArray.push(e);
				e = e.parent;
			}
			if (objArray.length > 0) {
				if (paramPanel == null) {
					paramPanel = new Sprite();
					paramPanel.x = 308;
//					paramPanel.y = _model.stage.height - 40;
					paramPanel.y = 10;
					paramArray = [];
				}
				if (_model.stage.contains(paramPanel) == false) {
					_model.stage.addChild(paramPanel);
				}
				for (var i:int = 0; i < paramArray.length; i++) {
					if (paramArray[i].parent) {
						paramArray[i].parent.removeChild(paramArray[i]);
					}
				}
				var offsetX:int = 0;
				for (var j:int = 0; j < objArray.length; j++) {
					var btn:CheatWhiteBtn = paramArray[j];
					if (btn == null) {
						btn = new CheatWhiteBtn();
						btn.addEventListener(CheatModel.DISPLAY_ITEM, clickObj);
						btn.addEventListener(CheatModel.MOVE_ITEM, moveObjcet);
						paramArray[j] = btn;
					}
					btn.setData(objArray[j]);
					btn.selected = false;
					btn.onMove = false;
					btn.x = offsetX;
					offsetX = btn.x + btn.width + 7;
					paramPanel.addChild(btn);
				}
				onMove = 0;
				if (resultPanel && _model.stage.contains(resultPanel)) {
					_model.stage.removeChild(resultPanel);
				}
			}
		}
		
		/**
		 * 显示当前元件
		 */
		private function showObject(e:ParamEvent):void
		{
			var isShow:Boolean = Boolean(e.param.isShow);
			var data:DisplayObject = DisplayObject(e.param.data);
			var dataParent:DisplayObject = data.parent;
			var offsetPos:Point = new Point();
			while (dataParent && dataParent != _model.stage) {
				offsetPos.x += dataParent.x;
				offsetPos.y += dataParent.y;
				dataParent = dataParent.parent;
			}
			if (redRectangle == null) {
				redRectangle = new Sprite();
			}
			redRectangle.graphics.clear();
			redRectangle.graphics.lineStyle(2, 0xff0000);
			redRectangle.graphics.drawRect(data.x+offsetPos.x, data.y+offsetPos.y, data.width, data.height);
			if (isShow) {
				_model.stage.addChild(redRectangle);
			} else {
				_model.stage.removeChild(redRectangle);
			}
		}
		
		/**
		 * 点击当前元件
		 */
		protected function clickObj(event:ParamEvent):void
		{
			var item:CheatWhiteBtn;
			for each (item in paramArray) {
				item.selected = false;
				item.onMove = false;
			}
			selectedItem = event.currentTarget as CheatWhiteBtn;
			selectedItem.selected = true;
			selectedItem.onMove = false;
			onMove = 0;
			analyze(selectedItem.data);
		}
		
		/**
		 * 分析元件
		 */
		private function analyze(data:*):void
		{
			var xml:XML = describeType(data);
			var xmlList:XMLList = xml.accessor;
			attributeArray = ["parent"];
			for each (var item:XML in xmlList) {
				if (item.@type == "int" || item.@type == "uint" || item.@type == "Number" || item.@type == "String" || item.@type == "Boolean") {
					if (item.@access == "readwrite" || item.@access == "readonly") {
						attributeArray.push(item.@name);
					}
				}
			}
			showResult();
		}
		
		/**
		 * 显示分析结果
		 */
		private function showResult():void
		{
			var str:String = "";
			var frequentStr:String = "";
			attributeArray.sort(Array.CASEINSENSITIVE);
			for each (var attrName:String in attributeArray) {
				str += attrName + ": " + String(selectedItem.data[attrName]);
				str += "\n";
				if (attrName == "x" || attrName == "y" || attrName == "width" || attrName == "height" || attrName == "text") {
					frequentStr += attrName + ": " + String(selectedItem.data[attrName]);
					frequentStr += "\n";
				}
			}
			if (resultPanel == null) {
				resultPanel = new CheatWhitePanel();
			}
			_model.stage.addChild(resultPanel);
			resultPanel.setData(str);
			resultPanel.setTop(frequentStr);
		}
	}
}