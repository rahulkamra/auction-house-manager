package model
{
	import controller.AIRUtils;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class GameItemVO
	{
		public function GameItemVO()
		{
		}
		
		public var name:String = "Test";
		public var costPrice:Number = 0;
		public var auctionHousePrice:Number = 0;
		
		public var imageURL:String;
		
		public var ingredients:ArrayCollection;//array of item quantutyVO
		public var searchTags:ArrayCollection;
		
		
		public function getFile():File
		{
			return AHML.Instance.currentGameDir.resolvePath(name);
		}
			
		
		public function save():void
		{
			AIRUtils.writeObjectAsync(getFile(),this,null);
		}
		
	}
}