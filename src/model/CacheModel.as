package model
{
	import flash.net.SharedObject;

	public class CacheModel
	{
		private static var _instance:CacheModel;
		private var _shareObj:SharedObject;
		
		public function CacheModel()
		{
			_shareObj = SharedObject.getLocal("hp/yzhof");
		}
		
		public static function getInstance():CacheModel
		{
			if (_instance == null) {
				_instance = new CacheModel();
			}
			return _instance;
		}
		
		public function getData(key:String):Object
		{
			if (_shareObj == null) {
				return null;
			}
			var obj:Object = null;
			try {
				//_sharedObject.flush();
				obj = _shareObj.data[key];
			} catch(e:Error) {
				return null;
			}
			return obj;
		}
		
		public function saveData(key:String, obj:Object):void
		{
			if (_shareObj == null) {
				return;
			}
			_shareObj.data[key] = obj;
		}
		
		public function removeData(key:String):void
		{
			if (_shareObj == null) {
				return;
			}
			delete _shareObj.data[key];			
		}
	}
}