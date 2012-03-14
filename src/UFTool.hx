import massive.haxe.log.Log;
import massive.haxe.util.TemplateUtil;
import massive.neko.cmd.CommandLineRunner;
import massive.neko.cmd.Console;
import massive.neko.cmd.ICommand;
import massive.neko.haxelib.Haxelib;
import massive.neko.io.File;

import cmd.InitCommand;
import cmd.CreateModelCommand;
import cmd.CreateControllerCommand;
import cmd.ServerCommand;

import haxe.macro.Expr;

class UFTool extends CommandLineRunner 
{
	static public function main():UFTool{return new UFTool();}

	public function new():Void
	{
		super();

		//haxelib = new Haxelib(console.dir.resolveFile("haxelib.xml"));
		//settings = new MlibSettings(console.dir.resolveFile(".mlib"));


		// if(settings.file.exists)
		// {
		// 	Log.debug(settings);
		// }

		mapCommand(
			InitCommand, 
			"init", ["i"], 
			"Creates a folder for the new project and a skeleton folder structure.", 
			TemplateUtil.getTemplate("help_init")
		);

		mapCommand(
			CreateModelCommand, 
			"createmodel", ["m"], 
			"Creates a new model for the current project.", 
			TemplateUtil.getTemplate("help_createModel")
		);

		mapCommand(
			CreateControllerCommand, 
			"createcontroller", ["c"], 
			"Creates a new controller for the current project.", 
			TemplateUtil.getTemplate("help_createController")
		);

		mapCommand(
			ServerCommand, 
			"server", ["s"], 
			"Launch a simple neko server for the current project.", 
			TemplateUtil.getTemplate("help_server")
		);

		run();
	}

	@:macro public static function load(filename:String)
	{
		filename = haxe.macro.Context.resolvePath("../" + filename);
		var string = neko.io.File.getContent(filename);
		
		var pos = haxe.macro.Context.currentPos();
		return { expr : EConst(CString(string)), pos : pos };
	}
}