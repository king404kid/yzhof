package
{
	import controller.CheatController;
	
	import flash.display.Stage;
	
	import model.CheatModel;

	public class DebugSystem
	{
		public function DebugSystem()
		{
		}
		
		public static function init(stage:Stage):void
		{
			CheatModel.getInstance().stage = stage;
			CheatController.getInstance();
		}
	}
}