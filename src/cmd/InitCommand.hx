package cmd;

import massive.neko.io.File;
import massive.neko.io.FileSys;
import massive.haxe.log.Log;
import massive.neko.cmd.Command;
import massive.neko.cmd.Console;
import massive.haxe.util.TemplateUtil;
import neko.db.MySQLAdmin;
import erazor.Parser;

using StringTools;
using neko.cmd.ConsoleTools;

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

	var projectName:String;

	override public function execute():Void
	{
		projectName = getName();

		// Later it would be better to create a zip at compile time
		// Include it in the haxelib (or as a resource using macro.Context.addResource)
		// And unpack it at runtime

		makeDirSkeleton();
		copyFiles();
		setupDatabase();
		
		trace ("Everything done!");
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

	private function makeDirSkeleton()
	{
		FileSys.createDirectory(projectName);
		FileSys.createDirectory(projectName + "/src");
		FileSys.createDirectory(projectName + "/bin");
		FileSys.createDirectory(projectName + "/doc");
		FileSys.createDirectory(projectName + "/src/controller");
		FileSys.createDirectory(projectName + "/src/model");
		FileSys.createDirectory(projectName + "/bin/view");
		FileSys.createDirectory(projectName + "/bin/css");
		FileSys.createDirectory(projectName + "/bin/js");
	}

	private function copyFile(fileName:String)
	{
		var resourceName = "skeleton_" + fileName.replace("/","_").replace(".","_");
		var content = TemplateUtil.getTemplate(resourceName);
		var newFileName = projectName + "/" + fileName;

		var file = console.dir.resolveFile(newFileName);
		file.createFile(content);
	}

	private function copyFiles()
	{
		copyFile("build.hxml");
		copyFile("README.md");
		copyFile(".gitignore");
		copyFile(".uftool");
		copyFile("src/Main.hx");
		copyFile("src/AppConfig.hx");
		// copyFile("src/MyConfig.hx");
		copyFile("src/controller/InstallController.hx");
	}

	/** Pass the config so far (server, port) and let us input the 
	username and password.  If "validate" is true, then keep trying
	until we get a username and password that actually work. */
	private function inputUsernamePassword(configSoFar:Dynamic, validate:Bool, defaultUsername:String)
	{
		var u:String, p:String, newConfig:Dynamic;

		var firstRun = true;
		do 
		{
			// If we're forcing validation, and we've already tried
			// and it's failed, let them know...
			if (firstRun) firstRun = false;
			else trace ("Access Denied.  Please try again");

			// Input USERNAME
			u = console.prompt("Username (default: "+defaultUsername+")");
			if (u == null) { u = defaultUsername; }

			// input PASSWORD
			do { 
				p = console.prompt("Password");
			} while (p == null);

			newConfig = {
				server: configSoFar.server,
				port: configSoFar.port,
				username: u,
				password: p,
				database: configSoFar.database
			};
		
		// if we are validating, keep looping until we stop getting 
		// the "AccessDenied" error.
		} while (validate == true && MySQLAdmin.attemptConnection(newConfig) == DBConnectionResult.AccessDenied);

		return newConfig;
	}

	private function setupDatabase()
	{
		// How this works:
		/*
		How this works:
		We step through each piece of the database config and
		input the values, and try them out.  This should result
		in different error message as each stage succeeds, and then
		will finally result in a "success" once everything is there.

		For the "username/password" and "database" steps, we ask for
		input, and if the input doesn't exist / work, we either
		  a) try another input
		  b) ask for super user details to create these
		*/

		// Default vars - these should be broken!
		var config = {
			server: "defaultServer",
			port: 1,
			username: "fakeUsername",
			password: "fakePassword567",
			database: "MyNonExistantDatabase"
		};
		
		// Use this throughout our "do" "while" loops to decide
		// whether or not to input a message
		var firstRun:Bool;

		// Get the server
		// do inputServer while attempt(server) == FailedToResolve
		firstRun = true;
		do 
		{
			// Print error message if it's not our first time
			if (firstRun) firstRun = false; 
			else trace ("Failed to resolve host.  Please try again");

			config.server = console.prompt("Server (default: localhost)");
			if (config.server == null) { config.server = "localhost"; }
		}
		while (MySQLAdmin.attemptConnection(config) == DBConnectionResult.FailedToResolve);

		// Get the port
		// do inputPort while attempt(s,p) == FailedToConnect
		firstRun = true;
		do 
		{
			// Print error message if it's not our first time
			if (firstRun) firstRun = false; 
			else trace ("Failed to connect on this port.  Please try again.");

			var portStr = console.prompt("Port (default: 3306)");
			config.port = Std.parseInt(portStr);
			if (config.port == null) { config.port = 3306; }
		}
		while (MySQLAdmin.attemptConnection(config) == DBConnectionResult.FailedToConnect);

		// Have a superuser config var that we may use
		var superuserConfig:Dynamic = null; 
		
		// Get the username and password, database
		config = inputUsernamePassword(config, false, projectName);
		config.database = console.prompt("Database (default: "+projectName+")");
		if (config.database == null) { config.database = projectName; }
		while (MySQLAdmin.attemptConnection(config) == DBConnectionResult.AccessDenied)
		{
			// If this is running, then the username, password, database
			// combo did not work.
			var choice = console.presentOptions("Access Denied.  You can either:", 
				[
					{ code: "1", text: "Use a superuser / root / admin account to create this user account and database" },
					{ code: "2", text: "Try another username, password and database that already exist" },
				]
			);
			switch (choice)
			{
				case "1":
					// get superuser access
					if (superuserConfig == null)
					{
						superuserConfig = inputUsernamePassword(config, true, "root");
					}
					
					// create database, account
					MySQLAdmin.createDatabase(superuserConfig, config.database);
					MySQLAdmin.createUserAccount(superuserConfig, config.username, config.password);
					MySQLAdmin.grantPrivileges(superuserConfig, config.database, config.username, config.server);

				case "2":
					// Keep trying new usernames passwords
					config = inputUsernamePassword(config, true, projectName);
					config.database = console.prompt("Database (default: "+projectName+")");
					if (config.database == null) { config.database = projectName; }

			}
		}

		if (MySQLAdmin.attemptConnection(config) == DBConnectionResult.Success)
		{
			// Create the MyConfig file based on our working credentials
			//
			// generate MyConfig.hx from template and save to a file
			//
			var string = TemplateUtil.getTemplate("tpl_MyConfig");
			var template = new erazor.Template(string);
			var output = template.execute({
				server: config.server,
				port: config.port,
				database: config.database,
				username: config.username,
				password: config.password
			});
			var file = console.dir.resolveFile(projectName + "/src/MyConfig.hx");
			file.createFile(output);
		}
		else
		{
			trace ("Even after all that we couldn't seem to connect okay...");
		}

			
	}

}

