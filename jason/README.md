This is your project's README!
==============================

Feel free to write it, delete it, replace it etc.

It is Markdown formatted, meaning that if you upload this
project to GitHub it will be nicely formatted.  It also 
means if someone opens it in a normal text editor, it will
look decent.

A few tips for UFront and UFtool
---------------------------------

UFront is web framework for the haxe language, and it compiles
to PHP, Neko and soon hopefully NodeJS.  It is an MVC framework,
meaning you structure you code as Models (the data structure, 
validation and database interaction), Views (the templates) and
Controllers (where stuff actually happens).  This allows you to 
write Web Apps that can grow in complexity as the project requires,
without things getting out of hand.

UFtool is a simple tool to help get you up and running with UFront 
faster.  Here are some of the commands

    haxelib run uftool init myproject

Initialises a new project called 'myproject'.  It will create a
directory and give you a basic skeleton of files to use.

    haxelib run uftool createmodel Client
    haxelib run uftool -m Client

Creates a model called "client" for the current project.  Models
are based on haxe's SPOD framework, so they integrate into your
database pretty easily.

#    haxelib run uftool createtable Client
#    haxelib run uftool -t Client
#
#Create a table in the database for the given model.  Currently, I have
#no support for updating the table or entering sample data, though
#both of these will be useful later.
#
#    haxelib run uftool createcontroller Invoicing
#    haxelib run uftool -c Invoicing
#### Do this from an InstallController
#
#

Creates a new controller called "InvoicingController".  Each controller
has a set of actions, which perform a separate action and render output 
to the client.

    haxelib run uftool createcontroller -scaffold Client
    haxelib run uftool -c -scaffold Client

This creates a controller based on "Scaffolding" for a model.  Scaffolding,
like in real life, allows you to quickly throw together a basic structure
while you build something more permanent around it.  For Web Projects, this
usually means meeting these basic functions

 * Create
 * Read
 * Update
 * Delete
 * List
 * Search

The "Scaffolding" we use here creates these basic functions for a given model.
For example, if we set up scaffolding for out client model, the framework will
automatically generate these functions:

 * Create a new client
 * Show a specific client
 * Update the details for a client
 * Delete a client
 * List all clients
 * Search all clients using a specific field

This is handy for getting up and running quickly!

    haxelib run uftool server

This compiles your project using "build.hxml", and load
`nekotools server` to start up a local server for the current
project.  The server will be available by visiting 
`http://localhost:2000` in a web browser.

Syntax to use: 
nekotools server -p 2000 -h localhost -d c:\your\web\root\ -rewrite
