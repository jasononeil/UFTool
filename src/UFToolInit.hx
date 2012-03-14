import massive.neko.io.FileSys;
import massive.neko.io.File;

class UFToolInit 
{
	var projectName:String;

	public function new(?name = "")
	{
		getName(name);
		neko.Lib.println("Creating new project: " + projectName);

		skeleton();
	}

	function getName(name)
	{
		// TODO: give a more useful warning if they entered a good name
		//       but the file already exists
		while (name == "" || neko.FileSystem.exists(name))
		{
			// Get a project name if none was given
			name = UFTool.input("Project Name");
		}
		
		projectName = name;
	}

	function skeleton()
	{
		FileSys.
		neko.FileSystem.createDirectory(projectName);
		massive.neko.io.FileSys.
	}
}