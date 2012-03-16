package neko.db;

class MySQLAdmin 
{
	public static function attemptConnection(config):DBConnectionResult
	{
		// assume it works.  If an error is thrown we'll change this...
		var result:DBConnectionResult = DBConnectionResult.Success;

		try 
		{
			neko.db.Mysql.connect({
				host : config.server,
				port : config.port,
				user : config.username,
				pass : config.password,
				socket : "",
				database : config.database
			});
		} catch (e:Dynamic)
		{
			//"502" "Failed to resolve host" - bad servername
			//"502" "Failed to connect on host" - bad port
			//"502" "Access denied" - bad username / bad pass
			//"55" "Failed to select database" - no database

			var error = Std.string(e);

			if (error.indexOf("Failed to resolve host") > 0)
			{
				result = DBConnectionResult.FailedToResolve;
			}
			else if (error.indexOf("Failed to connect on host") > 0)
			{
				result = DBConnectionResult.FailedToConnect;
			}
			else if (error.indexOf("Access denied") > 0)
			{
				result = DBConnectionResult.AccessDenied;
			}
			else if (error.indexOf("Failed to select database") > 0)
			{
				result = DBConnectionResult.NoDatabase;
			}
			else
			{
				trace ("An unknown error occurred:");
				trace (error);
				result = DBConnectionResult.UnknownError;
			}
		}
		return result;
	}

	public static function createDatabase(adminConfig, database:String)
	{
		try
		{
			// prepare the sql that creates our user
			var sql1:String = "CREATE DATABASE IF NOT EXISTS `" + database + "` ;";

			// run the sql
			runSql(adminConfig, sql1);
		}
		catch (e:Dynamic)
		{
			trace ("Failed to create the Database.  Here's the error");
			trace (e);
		}
	}

	public static function createUserAccount(adminConfig, username, password)
	{
		// this function should only be called once we've verified our adminConfig is correct, except for database.  Try the default "mysql" database...
		var server = adminConfig.server;

		try
		{

			// prepare the sql that creates our user
			var sql1:String = 
"CREATE USER '" + username + "'@'" + server + "' IDENTIFIED BY '" + password +"';";

 			var sql2:String = 
"GRANT USAGE ON * . * TO 
'" + username + "'@'" + server + "'
 IDENTIFIED BY '" + password +"' 
 WITH MAX_QUERIES_PER_HOUR 0 
 MAX_CONNECTIONS_PER_HOUR 0 
 MAX_UPDATES_PER_HOUR 0 
 MAX_USER_CONNECTIONS 0 ;";

			
			

			// run the sql
			runSql(adminConfig, sql1);
			runSql(adminConfig, sql2);

			
		}
		catch (e:Dynamic)
		{
			trace ("Failed to create the SQL account.  Here's the error");
			trace (e);
		}
	}

	public static function grantPrivileges(adminConfig, database:String, username:String, server:String)
	{
		try
		{
			// prepare the sql that creates our user
			var sql1:String = "GRANT ALL PRIVILEGES ON `" + database + "` . * TO '" + username + "'@'" + server + "';";

			// run the sql
			runSql(adminConfig, sql1);
		}
		catch (e:Dynamic)
		{
			trace ("Failed to grant permissions to the new user on the new database.  Here's the error");
			trace (e);
		}
	}

	public static function runSql(config:Dynamic, sql)
	{
		var conn = neko.db.Mysql.connect({
			host: config.server,
			port: config.port,
			user: config.username,
			pass: config.password,
			socket: null,
			database: "mysql"
		});

		var rs = conn.request(sql);
	}
}

enum DBConnectionResult
{
	FailedToResolve;
	FailedToConnect;
	AccessDenied;
	NoDatabase;
	UnknownError;
	Success;
}

typedef MySQLConfig = {
	host : String,
	port : Int,
	user : String,
	pass : String,
	socket : Null<String>,
	database : String
}