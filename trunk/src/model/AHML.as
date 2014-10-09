package model
{
	import flash.filesystem.File;
	
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
			
		
		public var currentGameName:String = "ArcheAge";
		
		public function get currentGameDir():File
		{
			if(currentGameName == "")
				return null;
			
			var nativePath:String = File.applicationDirectory.resolvePath("AHM\\Data\\"+currentGameName).nativePath
			return new File(nativePath);
		}
		
		
		public var allGameItems:ArrayCollection;
		
		
	}
}