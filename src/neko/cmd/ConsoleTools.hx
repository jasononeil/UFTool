package neko.cmd;

import massive.neko.cmd.Console;
using Lambda;

class ConsoleTools 
{
	public static function presentOptions(
		console:Console,
		description:String,
		options:Array<Option>
	)
	{
		neko.Lib.println(description);
		var validOptions = new Array<String>();
		for (o in options)
		{
			validOptions.push(o.code);
			neko.Lib.println("    (" + o.code + ") " + o.text);
		}
		var choice:String;
		do {
			choice = console.prompt("Your Choice");
		} while (choice != null && validOptions.has(choice) == false);
		
		return choice;
	}
}

typedef Option = {
	var code:String;
	var text:String;
}
