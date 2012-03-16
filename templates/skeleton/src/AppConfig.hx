/**
* This class defines the generic settings for your app.
* Only the person who writes the app should use this.
* If you're looking for settings to deploy the app, eg. Database
* Specific content, then look in "MyConfig.hx"
*/
class AppConfig 
{
	// Database Settings...
	public var databaseType:DatabaseType;
	public var mysqlSettings:MySQLSettings;

	public function new()
	{
		databaseType = DatabaseType.MySQL;

		mysqlSettings = {
			// set your settings in MyConfig

		}
		mysqlSettings.database
	}
}

enum DatabaseType {
	MySQL;
	// SQLite; // is this working yet?
	// PostgreSQL; // don't think this is working
}

typedef MySQLSettings = {
	server:String,
	port:Int,
	username:String,
	password:String,
	database:String,
	socket:String
}