package controller
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	
	
	public class AIRUtils
	{
		public function AIRUtils()
		{
		}
		
		public static function getFileList(folder:File , extension:String = "", isFolderIncluded:Boolean=true):Vector.<File>{
			try
			{
				var getDirectoryListing:Array = folder.getDirectoryListing();
				var dataToReturn:Vector.<File> = new Vector.<File>();
				
				for(var count:int = 0 ; count < getDirectoryListing.length ; count++)
				{
					var file:File = getDirectoryListing[count] as File;
					if(StringUtils.getFileExtension(file.name) == extension || extension == "")
					{
						if(isFolderIncluded)
						{
							dataToReturn.push(file);
						}
						else if(!isFolderIncluded && !file.isDirectory)
						{
							dataToReturn.push(file);
						}
						else
						{
							//don't add
						}
					}
				}
				return dataToReturn;
			}
			catch(e:Error)
			{
				trace(AIRUtils,"getFileList","Folder not found " + folder.nativePath);
			}
			
			return new Vector.<File>;
		}
		
		public static function getFileNamesAtPath(path:String, extension:String = "", isFolderIncluded:Boolean=true):Array
		{
			try
			{
				var folder:File = new File(path);
				var getDirectoryListing:Array = folder.getDirectoryListing();
				var dataToReturn:Array  = [];
				
				for(var count:int = 0 ; count < getDirectoryListing.length ; count++)
				{
					var file:File = getDirectoryListing[count] as File;
					if(StringUtils.getFileExtension(file.name) == extension || extension == "")
					{
						if(isFolderIncluded)
						{
							dataToReturn.push(file.name);
						}
						else if(!isFolderIncluded && !file.isDirectory)
						{
							dataToReturn.push(file.name);
						}
						else
						{
							//don't add
						}
					}
				}
				return dataToReturn;
			}
			catch(e:Error)
			{
				trace(AIRUtils,"getFileNamesAtPath","Folder not found " + path);
			}
			
			return [];
		}
		
		public static function getFileData(file:File):String
		{
			if(!file.exists)
			{
				trace(AIRUtils,"getFileData","File not found.");
				return null;
			}
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			var readUTFBytes:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			return readUTFBytes;
		}
		
		public static function getFileDataAsync(file:File,success:Function):void
		{
			if(!file.exists)
			{
				trace(AIRUtils,"getFileData","File not found. ==>" + file.url);
				success("");
				return;
			}
			
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE,function loadComplete(event:Event):void
			{
				var finalByteArray:ByteArray = new ByteArray();
				fileStream.readBytes(finalByteArray,0,fileStream.bytesAvailable);
				fileStream.close();
				
				finalByteArray.position = 0;
				success(finalByteArray.readUTFBytes(finalByteArray.bytesAvailable));
			});
			
			fileStream.openAsync(file,FileMode.READ);
		}
		
		
		public static function getFileByteArrayDataAsync(file:File,success:Function):void
		{
			if(!file.exists)
			{
				trace(AIRUtils,"getFileData",file.url + "  File not found.");
				success(null);
				return;
			}
			
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE,function loadComplete(event:Event):void
			{
				var finalByteArray:ByteArray = new ByteArray();
				fileStream.readBytes(finalByteArray,0,fileStream.bytesAvailable);
				fileStream.close();
				finalByteArray.position = 0;
				success(finalByteArray);
			});
			
			fileStream.openAsync(file,FileMode.READ);
		}
		
		public static function writeFile(file:File,fileData:String):void{
			var fileStream:FileStream = new FileStream()
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(fileData);
			fileStream.close();
		}
		
		public static function writeFileAsync(file:File,fileData:String,success:Function,fault:Function = null):void{
			var fileStream:FileStream = new FileStream()
			fileStream.openAsync(file, FileMode.WRITE);
			
			fileStream.addEventListener(IOErrorEvent.IO_ERROR,function _error(even:IOErrorEvent):void
			{
				if(fault != null)
				{
					fault();
				}
				trace(AIRUtils,"error",even.text +" Error writing file " + file.url);
			});
			
			fileStream.addEventListener(Event.CLOSE,function close(event:Event):void
			{
				fileStream.removeEventListener(Event.CLOSE,close);
				success();
			});
			
			fileStream.writeUTFBytes(fileData);
			
			fileStream.close();
		}
		
		
		public static function writeFileByteArrayAsync(file:File,fileData:ByteArray,success:Function):void{
			var fileStream:FileStream = new FileStream()
			fileStream.openAsync(file, FileMode.WRITE);
			
			fileStream.addEventListener(IOErrorEvent.IO_ERROR,function _error(even:IOErrorEvent):void
			{
				trace(AIRUtils,"error",even.text + " Error writing file " + file.url);
			});
			
			fileStream.addEventListener(Event.CLOSE,function close(event:Event):void
			{
				fileStream.removeEventListener(Event.CLOSE,close);
				if(success != null)
					success();
			});
			
			fileStream.writeBytes(fileData);
			fileStream.close();
		}
		
		public static function writeObjectAsync(file:File,fileData:Object,success:Function):void{
			var fileStream:FileStream = new FileStream()
			fileStream.openAsync(file, FileMode.WRITE);
			
			fileStream.addEventListener(IOErrorEvent.IO_ERROR,function _error(even:IOErrorEvent):void
			{
				Alert.show("error"+"Error writing file " + file.url);
			});
			
			fileStream.addEventListener(Event.CLOSE,function close(event:Event):void
			{
				Alert.show("Done");
				fileStream.removeEventListener(Event.CLOSE,close);
				if(success != null)
					success();
			});
			
			fileStream.writeObject(fileData);
			fileStream.close();
		}
		
		public static function exportByteArray(filePath:String, srcByteArray:ByteArray):void
		{
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeBytes(srcByteArray);
			fileStream.close();
		}
		
		public static function importByteArray(filePath:String):ByteArray
		{
			var destByteArray:ByteArray = new ByteArray();
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			fileStream.readBytes(destByteArray);
			fileStream.close();
			return destByteArray;
		}
		
		
		/**
		 *Returns a Vector consisting of data(ByteArray) objects for each File object passed in the fileList
		 * @param fileList the array of files to be used 
		 * @return Vector of ByteArray data objects
		 * 
		 */
		public static function getDataArrayFromFileArray(fileList:Vector.<File>):Vector.<ByteArray>
		{
			var dataArray:Vector.<ByteArray> = new Vector.<ByteArray>();
			var len:uint = fileList.length;
			
			for (var i:int = 0; i < len; i++) 
			{
				dataArray.push((fileList[i] as File).data);
			}
			
			return dataArray;
		}
		
		
		public static function getFileNameWithouExtension(fileNameWithExtension:String, delimiter:String="."):String
		{
			return fileNameWithExtension.split(delimiter)[0];
		}
		
		public static function getFileNamefromPath(filePath:String, delimiter:String="/"):String
		{
			var split:Array = filePath.split(delimiter);
			return split[split.length - 1];
		}
		
		public static function getFileDataAsByteArray(file:File):ByteArray
		{
			if(!file.exists)
			{
				trace(AIRUtils,"getFileDataAsByteArray","File not found.");
				return null;
			}
			
			var byteArray:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			fileStream.readBytes(byteArray, 0, fileStream.bytesAvailable);
			
			return byteArray;
		}
		
		
		
		public static function checkValidPath(path:String):Boolean
		{
			var returnValue:Boolean = false;
			try
			{
				var file:File = new File(path);
				if(file.exists)
				{
					returnValue = true;
				}
			}
			catch (error:Error)
			{
				returnValue = false;
			}
			return returnValue;
		}
		
		public static function getUrlFolderPath(filePath:String):String
		{
			var nameArray:Array = new Array();
			for (var count:int = filePath.length-1; count >=0; count--) 
			{
				if(filePath.charAt(count) != '/' && filePath.charAt(count) != '\\')
				{
					nameArray.push(filePath.charAt(count));
				}
				else
				{
					break;
				}
			}
			nameArray = nameArray.reverse();
			var fileName:String = nameArray.join("");
			return filePath.split(fileName).join("");
		}
		
		
		/**
		 *Returns the version string from the application descriptor file. 
		 * @param applicationRef
		 * @return the version number as string
		 * 
		 */
		public static function getApplicationVersion(applicationRef:*):String
		{
			var descriptor:XML = applicationRef.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespaceDeclarations()[0];
			var version:String = descriptor.ns::versionNumber;
			
			return version;
		}
		
		
		public static function getApplicationStorageDirectoryPath():String
		{
				return File.applicationStorageDirectory.nativePath;
		}
		
		
		public static function getFileSeparator():String
		{
				return File.separator;
		}
		
		public static function getUserNameFromUserDirectory():String
		{
				return File.userDirectory.name;
		}
		
		public static function isFileExist(fileUrl:String):Boolean
		{
				return new File(fileUrl).exists;
		}
		
	}
}