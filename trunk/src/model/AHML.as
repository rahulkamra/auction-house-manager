package model
{
	import managers.SingletonManager;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class AHML
	{
		public function AHML()
		{
		}
		
		public static function get Instance():AHML
		{
			return SingletonManager.getInstance(AHML) as AHML;
		}
		
		
		public var currentGameName:String;
		
		public function get currentGameDir():String
		{
			if(currentGameName == "")
				return "";
			
			return "/"+currentGameName+"/";
		}
		
		
		public var allGameItems:ArrayCollection;
		
		
	}
}