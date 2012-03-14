package cmd;

import massive.neko.io.File;
import massive.neko.io.FileSys;
import massive.haxe.log.Log;
import massive.neko.cmd.Command;
import massive.neko.cmd.Console;
import massive.haxe.util.TemplateUtil;

using StringTools;

class InitCommand extends Command
{
	private var model:File;
	
	public function new():Void
	{
		super();
		//addPreRequisite(PackageForHaxelibCommand);
	}
	
	override public function initialise():Void
	{
	}

	override public function execute():Void
	{
		var name = getName();

		// Later it would be better to create a zip at compile time
		// Include it in the haxelib (or as a resource using macro.Context.addResource)
		// And unpack it at runtime

		makeDirSkeleton(name);
		copyFiles(name);

		trace("Setup database");
	}

	private function getName():String
	{
		var name:String;
		var firstAttempt = true; // First attempt at a file name.  Used to tell if the file is looping because it already exists.
		do 
		{
			// If this loop has run more than once, then the project name already exists
			// So ask them to try again.
			if (!firstAttempt) { trace("Project already exists... try another name"); }
			
			// input a name, and keep going until we get a non empty value
			do 
			{
				name = console.prompt("Project Name");
			} while (name == null);

			firstAttempt = false;
		} while (FileSys.exists(name));
			

		return name;
	}

	private function makeDirSkeleton(name:String)
	{
		FileSys.createDirectory(name);
		FileSys.createDirectory(name + "/src");
		FileSys.createDirectory(name + "/bin");
		FileSys.createDirectory(name + "/doc");
		FileSys.createDirectory(name + "/src/controller");
		FileSys.createDirectory(name + "/src/model");
		FileSys.createDirectory(name + "/bin/view");
		FileSys.createDirectory(name + "/bin/css");
		FileSys.createDirectory(name + "/bin/js");
	}

	private function copyFile(projectName:String, fileName:String)
	{
		var resourceName = "skeleton_" + fileName.replace("/","_").replace(".","_");
		var content = TemplateUtil.getTemplate(resourceName);
		var newFileName = projectName + "/" + fileName;

		var file = console.dir.resolveFile(newFileName);
		file.createFile(content);
	}

	private function copyFiles(projectName:String)
	{
		copyFile(projectName, "build.hxml");
		copyFile(projectName, "README.md");
		copyFile(projectName, ".gitignore");
		copyFile(projectName, ".uftool");
		copyFile(projectName, "src/Main.hx");
		copyFile(projectName, "src/AppConfig.hx");
		copyFile(projectName, "src/MyConfig.hx");
		copyFile(projectName, "src/controller/InstallController.hx");
	}

	private function setupDatabase()
	{
		// input server, port, database, username, password

		// generate MyConfig.hx from template

		// 
	}

}