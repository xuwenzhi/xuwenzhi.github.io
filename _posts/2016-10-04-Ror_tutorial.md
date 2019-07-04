---
layout: post
title: Redis Src
tags: redis redis-internal
---

# Rails初始化

[Rails 应用的初始化过程](http://guides.ruby-china.org/initialization.html)

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



## Routing

config/routes.rb

[routing](http://guides.ruby-china.org/routing.html)

```
//Laravel的 route:list
rake routes
```
默认路由
```
get 'welcome/index'
```

REST路由
```
resources :articles
```

## Controller

app/controllers/*

创建路由
```
./bin/rails g controller articles
```


## View

app/views/*

Rails的模板命名由3部分组成

```
//一个例子 new.html.erb
{locale:[:en], formats:[:html], handlers:[:erb, :builder, :coffee]}
```

**Show Data From Controller**

controller:
```
def index
    @articles = Article.all
end
```
view:
```
<h1>Listing articles</h1>
<table>
  <tr>
    <th>Title</th>
    <th>Text</th>
  </tr>

  <% @articles.each do |article| %>
      <tr>
        <td><%= article.title %></td>
        <td><%= article.text %></td>
      </tr>
  <% end %>
</table>
```


##### Form

**表单构造器form_for**

[form_for API](http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for-label-Resource-oriented+style)

通过FormBuilder对象f来创建表单中的input等表单。

```
<%= form_for :article do |f| %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>
  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

> 上面这种表单叫做 “模型相关表单” ，因为这个表单使用了 **:article**作为模型，还有一种叫做模型无关表单，类似于搜索框，是无需和模型相关联的，具体例子：

```
<% form_tag "client_workouts/find" do%>
<%= text_field_tag :search_string%>
<%= submit_tag "搜索"%>
<% end %>
```

**Set Form Submit Url**

<%= form_for :article,url: articles_path do |f| %>

_注意url和前面的逗号不能有空格_

**Generated Form**

```
<form action="/articles" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="authenticity_token" value="xfddgk9gkY+XlK2hJPn8fU+A6JUGUSj537PFVn/Fi1/+uTOzQGYAsvMJg4KK/0XTgtZKklGYRDNgzCPAhiIIqg==" />
    <p>
      <label for="article_title">Title</label><br>
      <input type="text" name="article[title]" id="article_title" />
    </p>
    <p>
      <label for="article_text">Text</label><br>
      <textarea name="article[text]" id="article_text">
</textarea>
    </p>
    <p>
      <input type="submit" name="commit" value="Save Article" />
    </p>
</form>
```

## Handle Form

**Receive Parameters**

```
def create
    render plain: params[:article].inspect
end
```

**Save Data**

```
def create
  @article = Article.new(article_params)
 
  @article.save
  redirect_to @article
end
#定义允许接收的参数
private
  def article_params
    params.require(:article).permit(:title, :text)
  end
```

**Update Data**

```
def edit
    @article = Article.find(params[:id])
end
```

```
<h1>Editing article</h1>
<!-- method:patch 则对应REST架构，对应update方法-->
<%= form_for :article, url: article_path(@article), method: :patch do |f| %>
  <% if @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited
      this article from being saved:</h2>
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>
 
  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>
 
  <p>
    <%= f.submit %>
  </p>
<% end %>
 
<%= link_to 'Back', articles_path %>
```

```
def update
  @article = Article.find(params[:id])
 
  if @article.update(article_params)
    redirect_to @article
  else
    render 'edit'
  end
end

```

**Delete Data**

```
<%= link_to 'Delete', article_path(article),
                        method: :delete, data: { confirm: 'Are you sure?' } %>
```

**Common Form(new && edit)**

app/views/article/_form.html.erb

```
<%= form_for @article do |f| %>
    <% if @article.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@article.errors.count, "error") %> prohibited
        this article from being saved:</h2>
      <ul>
        <% @article.errors.full_messages.each do |msg| %>
            <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
<% end %>
<p>
  <%= f.label :title %><br>
  <%= f.text_field :title %>
</p>
<p>
  <%= f.label :text %><br>
  <%= f.text_area :text %>
</p>
<p>
  <%= f.submit %>
</p>
<% end %>
```

app/controllers/articles_controller.php
```
def new
    @article = Article.new
end
```

app/views/articles/new.html.erb

```
<h1>New Article!</h1>
<%= link_to 'Back', articles_path %>
<%= render 'form' %>
```

app/views/articles/edit.html.erb

```
<h1>New Article!</h1>
<%= link_to 'Back', articles_path %>
<%= render 'form' %>
```


## Model

app/models

**Create Model**
```
➜  newblog git:(master) ✗ ./bin/rails generate model Article title:string text:text
Running via Spring preloader in process 7386
      invoke  active_record
      create    db/migrate/20160925052329_create_articles.rb
      create    app/models/article.rb
      invoke    test_unit
      create      test/models/article_test.rb
      create      test/fixtures/articles.yml
```

**Relation Model**

Create new Comment model have relation with Article.

```
rails generate model Comment commenter:string body:text article:references
//comment belong article.
```

```
./bin/rake db:migrate RAILS_ENV=development
```

Relation route
```
resources :articles do
  resources :comments
end
```

Generate comment controller
```
rails generate controller Comments
```

Create function
```
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
```

Add comments form
```
<h2>Add a comment:</h2>
<%= form_for([@article, @article.comments.build]) do |f| %>
    <p>
      <%= f.label :commenter %><br>
      <%= f.text_field :commenter %>
    </p>
    <p>
      <%= f.label :body %><br>
      <%= f.text_area :body %>
    </p>
    <p>
      <%= f.submit %>
    </p>
<% end %>
```

Show article's comments 
```
<h2>Comments</h2>
<% @article.comments.each do |comment| %>
    <p>
      <strong>Commenter:</strong>
      <%= comment.commenter %>
    </p>

    <p>
      <strong>Comment:</strong>
      <%= comment.body %>
    </p>
<% end %>
```

Delete Relation Data

_dependent: : destroy_
```
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
            length: { minimum: 5 }
end
```


## Migration

**generate migrate file in db/migrate**

```
rails generate model
```

**execute migration**

```
rake db:migrate
```

**set migration env**

```
rake db:migrate RAILS_ENV=production
```


## Auth

**http simple auth**
```
http_basic_authenticate_with name: "xuwenzhi", password: "111111", except: [:index, :show]
```


## Redirect

```
redirect_to "/articles/#{@ad.id}"
```

----

# 其他记录


# 创建表迁移

```
bin/rails generate model ticket name:string seat_id_seq:string address:text price_paid:decimal email_address:string

// 执行写入数据库

bin/rails db:migrate RAILS_ENV=development

// 新增字段phone
bin/rails g migration AddPhoneToTickets phone:string
// 继续执行写入
bin/rails db:migrate RAILS_ENV=development
```

# 运行表迁移

```
rake db:migrate
```


# CURD生成器

```
bin/rails generate scaffold article title:string content:text author:string 

bin/rails db:migrate RAILS_ENV=development
```

# 创建Model

```
bin/rails g model ad name:string description:text price:decimal seller_id:integer email:string img_url:string

# 插入数据库

bin/rake db:migrate
```

# 创建控制器

```
bin/rails g controller ads
```



# 超级模板

app/views/layouts/ads.html.erb
```
<html>
<head>
<title>
  Ads :<%= controller.action_name %>

</title>
</head>
<body>
<%= yield %>
</body>
</html>
```

app/views/ads/index.html.erb

```
<% @ads.each do |ad| %>
    <p><a href="/ads/<%=ad.id%>"><%= ad.name %></a></p>
<% end %>
```


# 关系如何处理?

加入航班和航班所拥有的座位这是一种关系，那么我只需要在航班的model中定义

```
class Flight < ApplicationRecord
  has_many :seats
end

```

但是要注意，之所以能这样使用是因为flight表和seat表中是通过强制的约定实现的，比如seat表中一定存在flight_id字段才可以，这样的话，在航班所属的座位就作为@flight的一个属性存在，即

```
@flight = Flight.find(params[:id])
@seats = @flight.seats
```

当然，这种关系也不是一定要存在，还可以通过查询的方式获取该航班下的座位

```
@seats = Seat.where(:flight_id => params[:id])
```


# Routes

[http://guides.ruby-china.org/routing.html](http://guides.ruby-china.org/routing.html)

## 配置

```
config/route.rb
```

## 默认路由

```
root 'welcome#index'
```

## 让route和controller连接起来

```
// example/com/index链接将映射到index_controller.rb的index方法
get 'index', to: 'index#index'
```

## URL传参

```
get 'blog/:id', to: 'blog#id'
```

## REST路由

```
resource :articles
```

```
➜  newblog git:(master) ✗ rake routes
       Prefix Verb   URI Pattern                  Controller#Action
         root GET    /                            welcome#index
        index GET    /index(.:format)             index#index
     articles GET    /articles(.:format)          articles#index
              POST   /articles(.:format)          articles#create
  new_article GET    /articles/new(.:format)      articles#new
 edit_article GET    /articles/:id/edit(.:format) articles#edit
      article GET    /articles/:id(.:format)      articles#show
              PATCH  /articles/:id(.:format)      articles#update
              PUT    /articles/:id(.:format)      articles#update
              DELETE /articles/:id(.:format)      articles#destroy
```

#### 一次声明多个REST路由
```
resources :photos, :books, :videos
```

#### 指定controller
```
resources :photos, controller: 'images'
```

## 控制器命名空间

```
namespace :admin do
    resources :user
end
```

```
➜  newblog git:(master) ✗ ./bin/rails g controller admin/user
Running via Spring preloader in process 21811
      create  app/controllers/admin/user_controller.rb
      invoke  erb
      create    app/views/admin/user
      invoke  test_unit
      create    test/controllers/admin/user_controller_test.rb
      invoke  helper
      create    app/helpers/admin/user_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/admin/user.coffee
      invoke    scss
      create      app/assets/stylesheets/admin/user.scss
```

[http://192.168.33.10:3000/admin/user](http://192.168.33.10:3000/admin/user)


## 去掉命名空间的前缀

如上，如何使用[http://192.168.33.10:3000/user](http://192.168.33.10:3000/user)，就能访问到上面对应的admin/user_controller.rb呢？

```
scope module: 'admin' do
    resources :user
end
```
或者:

```
resources :user, module: 'admin'
```

## 路由映射到命名空间中的action

即使用[http://192.168.33.10:3000/admin/articles](http://192.168.33.10:3000/admin/articles)这种方式访问article_controller.rb。
```
scope '/admin' do
    resources :articles
end
```
或者:
```
resources :articles, path: '/admin/articles'
```


## REST嵌套资源

文章和文章评论的关系在Model中可以使用这样的方式来对应。
```
class Articles < ActiveRecord::Base
  has_many :comments
end
 
class Comments < ActiveRecord::Base
  belongs_to :articles
end
```
类似的，在路由中也能反映出这样的关系
```
resources :articles do
    resources :comments
end
```

即可以使用[http://192.168.33.10:3000/articles](http://192.168.33.10:3000/articles)来访问文章；使用[http://192.168.33.10:3000/articles/10/comments](http://192.168.33.10:3000/articles/10/comments)来访问文章对应的评论。


# Controller

## Controller基类
Rails的控制器都继承自ApplicationController，而ApplicationController继承自ActionController::Base
```
class ArticlesController < ApplicationController
    
end
```
## 参数过滤器

```
class ArticlesController < ApplicationController
  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
```

指定参数类型
```
//指定id必须为数组
params.permit(id: [])
```

嵌套参数
```
params.permit(:name, { emails: [] },hobbies: [] }])

```

# Rails验证器

rails的验证器是一种检查数据合法性的工具，通常我们在controller层对view提交上来的数据进行合法性检验，然而rails的验证器是在model层对数据进行验证，当在controller层执行 **.save** 或者 **.update_attributes**操作之前会自动执行验证器检验。

具体用法在model中添加规则，比如规定某个字段必须为数字时:

```
class Article < ApplicationRecord
  validates_numericality_of :author_uid
end
```

## 显示错误信息

当验证失败时，页面需要回到表单提交页，而不是跳转到数据的详情页，这是很正常的，然而存在这样的事情，当验证器无法通过时，controller需要知道model没有保存成功，怎么做呢?

```
if @article.save
    redirect_to "/article/#{@article.id}"
else
    render :template => "articles/new"
```

当然，articles/new的模板的<form>中需要存在这样的域用于显示错误

<%=f.error_message%>

## 其他验证器:

```
// 验证必填字段
validates_presence_of :field_name
//验证长度
validates_presence_of :field_name, :maximum=>32
//使用正则表达式验证
validates_format_of :field_name, :with=>/regular
//检查数据表中有没有与其相同的数据
validates_uniqueness_of :field_name
//检查域中是有一个给定的值
validates_inclusion_of :field_name, :in=>[value1, value2]

```

## 跳过验证器

```
model.save(false)
model.update_attributes(false)
```


## 自定义验证器

```
class Seat < ApplicationRecord
def validator
    if(baggage > 100)
        errors.add_to_base("你的行李太重了!")
    end
end
end
```


[MORE](https://github.com/ruby-china/rails-guides/blob/master/source/CN/active_record_validations_callbacks.textile)


# Exception

## 默认的 500 和 404 模板

public/500.html


# Log

日志文件目录

```
log/development.log
# -- 
log/test.log
```

## 过滤日志

过滤特定请求参数
```
config.filter_parameters << :password
```

# Security

## 强制使用 HTTPS 协议

```
force_ssl
```
设置隔离
```
force_ssl only: :cheeseburger
# or
force_ssl except: :cheeseburger
```


## HTTP 身份认证

#### 基本身份认证
```
http_basic_authenticate_with name: "xuwenzhi", password: "111111", except: [:index, :show]
```

#### 摘要身份认证

```
USERS = { "xuwenzhi" => "111111" }
 
before_action :authenticate
private
    def authenticate
      authenticate_or_request_with_http_digest do |username|
        USERS[username]
      end
    end
```

# ActiveRecord

[http://guides.ruby-china.org/active_record_querying.html](http://guides.ruby-china.org/active_record_querying.html)


# 数据库查询器

假如有这样的数据表article,有title、content等字段，现在有一个搜索功能，需要通过title来查找数据，这时我们可以使用rails提供的数据库查询器功能，具体的做法是

```
@articles = Article.find_all_by_title(params[:search_string])
```

那么，需求来了，如果也需要提供content查找的话，该怎么做呢？

```
@articles = Article.find(:all, :conditions => ["title = ? OR content => ?",  params[:search_string], pamras[:search_string]])
```


# Session

## 在Rails中有几种方式存储Session

- ActionDispatch::Session::CookieStore：所有数据都存储在客户端

- ActionDispatch::Session::CacheStore：数据存储在 Rails 缓存里

- ActionDispatch::Session::ActiveRecordStore：使用 Active Record 把数据存储在数据库中（需要使用 activerecord-session_store gem）

- ActionDispatch::Session::MemCacheStore：数据存储在 Memcached 集群中（这是以前的实现方式，现在请改用 CacheStore）


## 默认模式

CookieStore

## 配置文件

config/initializers/session_store.rb

```
# Be sure to restart your server when you modify this file.

# 相关联cookie的名字
# 后面的 :domain键可以指定哪些域可以使用此cookie
Rails.application.config.session_store :cookie_store, key: '_newblog_session', domain: ".example.com"

```

## cookie秘钥

config/secrets.yml

```
# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure the secrets in this file are kept private
# if you're sharing your code publicly.

development:
  secret_key_base: e23e86f...

test:
  secret_key_base: 9aa519c...

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

## session get/create/delete

```
def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
end
```

```
def create
    if user = User.authenticate(params[:username], params[:password])
      # Save the user ID in the session so it can be used in
      # subsequent requests
      session[:current_user_id] = user.id
      redirect_to root_url
    end
end
```

```
def destroy
    # Remove the user id from the session
    @_current_user = session[:current_user_id] = nil
    redirect_to root_url
end
```


> 删除会话中的数据是把键的值设为 nil，但要删除 cookie 中的值，要使用 cookies.delete(:key) 方法。

## Flash

> Flash 是会话的一个特殊部分，每次请求都会清空。也就是说，其中存储的数据只能在下次请求时使用，可用来传递错误消息等。

```
class LoginsController < ApplicationController
  def destroy
    redirect_to root_url, notice: "You have successfully logged out."
  end
end
```

```
<html>
  <!-- <head/> -->
  <body>
    <% flash.each do |name, msg| -%>
      <%= content_tag :div, msg, class: name %>
    <% end -%>
 
    <!-- more content -->
  </body>
</html>
```



# Cookie

## 配置文件

config/initializers/cookies_serializer.rb

> Rails 还提供了签名 cookie 和加密 cookie，用来存储敏感数据。签名 cookie 会在 cookie 的值后面加上一个签名，确保值没被修改。加密 cookie 除了会签名之外，还会加密，让终端用户无法读取。

```
# Be sure to restart your server when you modify this file.

Rails.application.config.action_dispatch.cookies_serializer = :json
```
1. :json
2. :marshal
3. :hybrid : 读取时，Rails 会自动返序列化使用 Marshal 序列化的 cookie，写入时使用 JSON 格式。


## 自定义序列化模式

```
# MyCustomSerializer需要定义load和dump方法
Rails.application.config.action_dispatch.cookies_serializer = MyCustomSerializer
```

## Cookie create/delete

```
//set
cookie[:key] = value

//delete
cookie.delete(:key)
```


# json VS. marshal

[shilov/redis_json_marshal_eval_benchmarks.rb](https://gist.github.com/shilov/1691428)


# Reference

[Rails 实践](https://www.gitbook.com/book/liwei78/rails-practice/details)



