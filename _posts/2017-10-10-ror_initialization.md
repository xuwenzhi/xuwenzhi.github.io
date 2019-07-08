---
layout: post
title: Ruby on Rails Initialization
tags: ruby rails
---

# Rails初始化

<!-- more -->

## 启动

> Rails应用通常以rails console 或 rails server启动


#### 1.railties/bin/rails

```
//载入railties/bin/rails
version = ">= 0"
load Gem.bin_path('railties', 'rails', version)
```

```
//载入cli
require "rails/cli"
```

```
//执行rails
Rails::AppRailsLoader.exec_app_rails
```

###### What's the Railties?
[http://api.rubyonrails.org/classes/Rails/Railtie.html](http://api.rubyonrails.org/classes/Rails/Railtie.html)

> Rails::Railtie is the core of the Rails framework and provides several hooks to extend Rails and/or modify the initialization process.


#### 1.2 railties/lib/rails/app_rails_loader.rb

> exec_app_rails模块的主要功能是去执行你的Rails应用中bin/rails
```
//执行rails server命令
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

_APP_PATH需要在后来的rails command中使用
../config/boot用来载入bundle_

#### 1.4 config/boot.rb

```
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' # Set up gems listed in the Gemfile.
```
_标准的Rails应用通过Gemfile来管理应用依赖，此处用于声明Gemfile命令，并且使用bundler/setup设置_


#### 1.5 rails/commands.rb

当config/boot.rb执行完后，接下来的是rails/commands，这个文件于帮助解析别名，类似于

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
_比如当执行rails s 时，此处会将s替换为server_


#### 1.6 rails/commands/command_tasks.rb

当键入错误的rails命令，run_command函数会抛出一个错误信息。当键入正确匹配的命令时，则会执行响应的命令。

```
//commands_tasks.rb

COMMAND_WHITELIST = %(plugin generate destroy console server dbconsole application runner new version help)
 
def run_command!(command)
  command = parse_command(command)
  if COMMAND_WHITELIST.include?(command)
    send(command)
  else
    write_error_message(command)
  end
end

//当键入rails server命令
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
动作分发(Action Dispatch)是Rails框架中的路由等组件。它增强了路由、Session和Middleware的功能。


#### 1.8 rails/commands/server.rb
这个文件中定义的Rails::Server类是继承自Rack::Server类的。当Rails::Server.new被调用时，会在 rails/commands/server.rb中调用一个initialize方法。


What's the Rack?
> Now, say you’re a web server. You have this Rails app loaded in you. And some browser came to you with that request having path ‘/users’. As a server you understand this HTTP request. But you don’t know what to do with it. You have to give it to your Rails app, because it knows very well what to do with such a request.

> There is a problem though. Your Rails app does not understand browser requests directly. You need to translate it in a way that he can make sense of it, work with it and then give you a response which you yourself can understand. But the Rails app is kind of a nut-job and doesn’t co-operate easily. So you take the app to a counsellor, to come up with a system.

> The counsellor’s name is ‘Rack’. He says, ‘Look Rails app, the server is ready to work together. He’s going to translate the HTTP request in a format that I’ll tell him to. This format will be easy for you to understand. In return, you have to give him a response that he can easily work with. I’ll tell you how your response should look like. Okay?’

[What's Rack in Ruby/Rails](http://blog.gauravchande.com/what-is-rack-in-ruby-rails)
[Understanding Rack apps and middleware](https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware)


#### 1.9 Rack: lib/rack/server.rb
Rack::Server会为所有基于Rack的应用提供服务接口，现在它已经是Rails框架的一部分了。

此时主要做的事情是:

```
obj_rack_server = new Rack::Server
obj_rack_server->initialize()
//再然后回到rails/commands/server.rb

obj_rack_server->set_environment()
```

//以及一些Web Server相关Host、Port等相关参数的配置

#### 1.10 config/application
当require APP_PATH操作执行完毕后。config/application.rb 被载入。


#### 1.11 Rails::Server#start
config/application载入后，server.start方法被调用。


#### 1.12 config/environment.rb
这是config.ru (rails server)和信使(Passenger)都要用到的文件，是两者交流的媒介。之前的操作都是为了创建Rack和Rails。

这个文件是以引用 config/application.rb开始

#### 1.13 config/application.rb
这个文件需要引用config/boot.rb。

## 加载Rails

接下来:

```
require 'rails/all'
```

#### 2.1 railties/lib/rails/all.rb
本文件中将引用和Rails框架相关的所有内容：

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

至此，Rails相关的所有组件都加载完毕。


#### 2.2 回到config/environment.rb

rails/application.rb将会调用我们自定义的Rails应用(比如blog):Rails.application.initialize!

```
# Initialize the Rails application.
Rails.application.initialize!
```


#### 2.3 railties/lib/rails/application.rb(调用过程)

```
def initialize!(group=:default) #:nodoc:
  raise "Application has been already initialized." if @initialized
  run_initializers(group, self)//调用railties/lib/rails/initializable.rb中的run_initializers
  @initialized = true
  self
end
```

```
//railties/lib/rails/initializable.rb中的run_initializers
def run_initializers(group=:default, *args)
  return if instance_variable_defined?(:@ran)
  initializers.tsort_each do |initializer|
    initializer.run(*args) if initializer.belongs_to?(group)
  end
  @ran = true
end
```


# refer

[Rails 应用的初始化过程](http://guides.ruby-china.org/initialization.html)
