package managers
{
	import flash.utils.Dictionary;

	public class SingletonManager
	{
		
		public function SingletonManager()
		{
		}
		private static var _dict:Dictionary = new Dictionary(true);
		
		public static function getInstance(_class:Class):*
		{
			if(_dict[_class] == null)
			{
				_dict[_class] = new _class();
			}
			return _dict[_class];
		}
		
	}
}