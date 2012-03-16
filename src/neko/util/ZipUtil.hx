package neko.util;

import neko.Lib;
import massive.neko.io.FileSys;
import neko.io.Path;

import neko.zip.Reader;
import neko.zip.Writer;
import haxe.io.Bytes;

import massive.neko.io.File;
import neko.FileSystem;

class ZipUtil 
{
	public static function unzipToDirectory(targetDir:File, sourceZip:File):Void
	{
		if (!sourceZip.exists) throw "Error: source zip file not found";

		// if the targetDir doesn't exist, create it
		if (!targetDir.exists || !targetDir.isDirectory)
		{
			targetDir.parent.createDirectory(targetDir.path);
		}

		// Set cwd as the target
		FileSys.setCwd(targetDir.nativePath);

		// Get entries of the zip file
		var entries:Array<Dynamic> = neko.zip.Reader.readZip();
	}
}