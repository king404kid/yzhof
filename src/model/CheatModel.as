package model
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;

	public class CheatModel extends EventDispatcher
	{
		public static const SHOW_OBJECT:String = "SHOW_OBJECT";
		public static const CLOSE_PANEL:String = "CLOSE_PANEL";
		public static const DISPLAY_ITEM:String = "DISPLAY_ITEM";
		public static const MOVE_ITEM:String = "MOVE_ITEM";
		
		public var stage:Stage;
		private static var _instance:CheatModel;
		
		public function CheatModel()
		{
		}
		
		public static function getInstance():CheatModel
		{
			if (_instance == null) {
				_instance = new CheatModel();
			}
			return _instance;
		}
	}
}