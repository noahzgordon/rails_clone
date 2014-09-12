# Ruby on 'Trails'

*To test out the framework, clone the directory and navigate to it in your terminal. Then run:

<code>ruby bin/test_server.rb</code>

A clone of Rails, the popular application development framework.

Much of the work on this project was done with the guidance and assistance
of App Academy's top-notch instructurs. But the following features were built
up from scratch, all by my lonesome!

##Bonus Features:
+ Consolidation of files into an intuitive structure.
  - System files are located in the 'lib' directory, and execution files are located in the 'bin' directory. Subject to change.
+ The Flash
  - for quick and easy errors/notices!
  - messages are stored on a cookie and wiped on subsequent requests. 
+ CSRF protection.
  - via an authenticity token stored on the session cookie.
+ Functional URL Helpers
	- Uses Ruby metaprogramming to defined a custom URL helper method on a controller whenever a new route is called.
+ ActiveRecord
  - the largest addition; allows Rails models to interact and fetch dynamically from a SQLite database.
  - SQLObjects (similar to ActiveRecord::Base) can persist to the database via instance methods, and can be fetched via the "all" and "where" methods.
  - Heavy use Ruby metaprogramming and custom SQL queries.
  - IN PROGRESS: Implementation of a Relation class which allows method calls to be chained.

###To-Do
+ Completion of the ActiveRecord Relation, with chainable #where and #includes methods.
+ a routes.rb file which automatically writes routes.
+ URL Helpers and URLHelper module.
+ link_to and button_to helpers.
+ support for rendering partials.
+ nested routing.

