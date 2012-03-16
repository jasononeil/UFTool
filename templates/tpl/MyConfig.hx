import AppConfig;

class MyConfig extends AppConfig
{
	function new()
	{
		// Load the default settings for this App
		super();

		mysqlSettings.server = "@server";
		mysqlSettings.port = @port;
		mysqlSettings.database = "@database";
		mysqlSettings.username = "@username";
		mysqlSettings.password = "@password";
	}
}
