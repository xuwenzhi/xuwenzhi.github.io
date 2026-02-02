---
layout: post
title: Ruby on Rails Initialization
tags: ruby rails
---

# Rails Initialization

<!-- more -->

## Startup

> Rails applications are typically started with rails console or rails server


#### 1. railties/bin/rails

```
// Load railties/bin/rails
version = ">= 0"
load Gem.bin_path('railties', 'rails', version)
```

```
// Load cli
require "rails/cli"
```

```
// Execute rails
Rails::AppRailsLoader.exec_app_rails
```

###### What's Railties?
[http://api.rubyonrails.org/classes/Rails/Railtie.html](http://api.rubyonrails.org/classes/Rails/Railtie.html)

> Rails::Railtie is the core of the Rails framework and provides several hooks to extend Rails and/or modify the initialization process.


#### 1.2 railties/lib/rails/app_rails_loader.rb

> The main function of the exec_app_rails module is to execute bin/rails in your Rails application

```
// Execute rails server command
exec ruby bin/rails server
```

#### 1.3 bin/rails

```
#!/usr/bin/env ruby
load File.expand_path('../spring', __FILE__)
APP_PATH = File.expand_path('../../config/application', __FILE__)
require_relative '../config/boot'
require 'rails/commands'
```

_APP_PATH needs to be used in rails command later
../config/boot is used to load bundle_

#### 1.4 config/boot.rb

```
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' # Set up gems listed in the Gemfile.
```
_Standard Rails applications manage application dependencies through Gemfile. This is used to declare the Gemfile command and set up using bundler/setup_


#### 1.5 rails/commands.rb

After config/boot.rb executes, next is rails/commands. This file helps parse aliases, similar to:

```
aliases = {
  "g"  => "generate",
  "d"  => "destroy",
  "c"  => "console",
  "s"  => "server",
  "db" => "dbconsole",
  "r"  => "runner"
}
```
_For example, when executing rails s, this will replace s with server_


#### 1.6 rails/commands/command_tasks.rb

When an incorrect rails command is entered, the run_command function throws an error message. When a correctly matching command is entered, the corresponding command is executed.

```
// commands_tasks.rb

COMMAND_WHITELIST = %(plugin generate destroy console server dbconsole application runner new version help)

def run_command!(command)
  command = parse_command(command)
  if COMMAND_WHITELIST.include?(command)
    send(command)
  else
    write_error_message(command)
  end
end

// When rails server command is entered
def server
  set_application_directory!
  require_command!("server")

  Rails::Server.new.tap do |server|
    # We need to require application after the server sets environment,
    # otherwise the --environment option given to the server won't propagate.
    require APP_PATH
    Dir.chdir(Rails.application.root)
    server.start
  end
end

```

#### 1.7 actionpack/lib/action_dispatch.rb
Action Dispatch is the routing and other components in the Rails framework. It enhances the functionality of routing, sessions, and middleware.


#### 1.8 rails/commands/server.rb
The Rails::Server class defined in this file inherits from the Rack::Server class. When Rails::Server.new is called, an initialize method is called in rails/commands/server.rb.


What's Rack?
> Now, say you're a web server. You have this Rails app loaded in you. And some browser came to you with that request having path '/users'. As a server you understand this HTTP request. But you don't know what to do with it. You have to give it to your Rails app, because it knows very well what to do with such a request.

> There is a problem though. Your Rails app does not understand browser requests directly. You need to translate it in a way that he can make sense of it, work with it and then give you a response which you yourself can understand. But the Rails app is kind of a nut-job and doesn't co-operate easily. So you take the app to a counsellor, to come up with a system.

> The counsellor's name is 'Rack'. He says, 'Look Rails app, the server is ready to work together. He's going to translate the HTTP request in a format that I'll tell him to. This format will be easy for you to understand. In return, you have to give him a response that he can easily work with. I'll tell you how your response should look like. Okay?'

[What's Rack in Ruby/Rails](http://blog.gauravchande.com/what-is-rack-in-ruby-rails)
[Understanding Rack apps and middleware](https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware)


#### 1.9 Rack: lib/rack/server.rb
Rack::Server provides a service interface for all Rack-based applications and is now part of the Rails framework.

The main things done at this point are:

```
obj_rack_server = new Rack::Server
obj_rack_server->initialize()
// Then back to rails/commands/server.rb

obj_rack_server->set_environment()
```

// And some web server related Host, Port and other parameter configurations

#### 1.10 config/application
After the require APP_PATH operation is complete, config/application.rb is loaded.


#### 1.11 Rails::Server#start
After config/application is loaded, the server.start method is called.


#### 1.12 config/environment.rb
This is the file used by both config.ru (rails server) and Passenger, serving as the medium for communication between them. Previous operations were to create Rack and Rails.

This file starts by referencing config/application.rb

#### 1.13 config/application.rb
This file needs to reference config/boot.rb.

## Loading Rails

Next:

```
require 'rails/all'
```

#### 2.1 railties/lib/rails/all.rb
This file will reference all content related to the Rails framework:

```
require "rails"
%w(
  active_record
  action_controller
  action_view
  action_mailer
  rails/test_unit
  sprockets
).each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end
```

At this point, all Rails-related components are loaded.


#### 2.2 Back to config/environment.rb

rails/application.rb will call our custom Rails application (e.g., blog): Rails.application.initialize!

```
# Initialize the Rails application.
Rails.application.initialize!
```


#### 2.3 railties/lib/rails/application.rb (calling process)

```
def initialize!(group=:default) #:nodoc:
  raise "Application has been already initialized." if @initialized
  run_initializers(group, self) // Call run_initializers in railties/lib/rails/initializable.rb
  @initialized = true
  self
end
```

```
// run_initializers in railties/lib/rails/initializable.rb
def run_initializers(group=:default, *args)
  return if instance_variable_defined?(:@ran)
  initializers.tsort_each do |initializer|
    initializer.run(*args) if initializer.belongs_to?(group)
  end
  @ran = true
end
```


# Reference

[Rails Application Initialization Process](http://guides.ruby-china.org/initialization.html)
