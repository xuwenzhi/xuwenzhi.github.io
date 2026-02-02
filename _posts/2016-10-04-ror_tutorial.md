---
layout: post
title: Ruby on Rails Tutorial
tags: ruby rails
---

## Routing

config/routes.rb

<!-- more -->

[routing](http://guides.ruby-china.org/routing.html)

```
// Laravel's route:list equivalent
rake routes
```

Default Route
```
get 'welcome/index'
```

REST Routes
```
resources :articles
```

## Controller

app/controllers/*

Create Controller
```
./bin/rails g controller articles
```


## View

app/views/*

Rails template naming consists of 3 parts:

```
// An example: new.html.erb
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

**Form Builder form_for**

[form_for API](http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for-label-Resource-oriented+style)

Use the FormBuilder object f to create form inputs and other form elements.

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

> The form above is called a "model-related form" because it uses **:article** as the model. There's also a model-independent form, similar to a search box, which doesn't need to be associated with a model. Here's an example:

```
<% form_tag "client_workouts/find" do%>
<%= text_field_tag :search_string%>
<%= submit_tag "Search"%>
<% end %>
```

**Set Form Submit URL**

<%= form_for :article,url: articles_path do |f| %>

_Note: There must be no space between url and the preceding comma_

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
# Define permitted parameters
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
<!-- method:patch corresponds to REST architecture, maps to update method-->
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

**Common Form (new && edit)**

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

Create new Comment model that has a relation with Article.

```
rails generate model Comment commenter:string body:text article:references
// comment belongs to article.
```

```
./bin/rake db:migrate RAILS_ENV=development
```

Relation Route
```
resources :articles do
  resources :comments
end
```

Generate Comment Controller
```
rails generate controller Comments
```

Create Function
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

Add Comments Form
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

Show Article's Comments
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

Delete Related Data

_dependent: :destroy_
```
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
            length: { minimum: 5 }
end
```


## Migration

**Generate Migrate File in db/migrate**

```
rails generate model
```

**Execute Migration**

```
rake db:migrate
```

**Set Migration Environment**

```
rake db:migrate RAILS_ENV=production
```


## Auth

**HTTP Simple Auth**
```
http_basic_authenticate_with name: "xuwenzhi", password: "111111", except: [:index, :show]
```


## Redirect

```
redirect_to "/articles/#{@ad.id}"
```

----

# Other Notes


# Create Table Migration

```
bin/rails generate model ticket name:string seat_id_seq:string address:text price_paid:decimal email_address:string

// Execute and write to database

bin/rails db:migrate RAILS_ENV=development

// Add new phone field
bin/rails g migration AddPhoneToTickets phone:string
// Continue execution and write
bin/rails db:migrate RAILS_ENV=development
```

# Run Table Migration

```
rake db:migrate
```


# CRUD Generator

```
bin/rails generate scaffold article title:string content:text author:string

bin/rails db:migrate RAILS_ENV=development
```

# Create Model

```
bin/rails g model ad name:string description:text price:decimal seller_id:integer email:string img_url:string

# Insert into database

bin/rake db:migrate
```

# Create Controller

```
bin/rails g controller ads
```



# Super Template

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


# How to Handle Relationships?

If there's a relationship between flights and seats that belong to flights, I just need to define in the flight model:

```
class Flight < ApplicationRecord
  has_many :seats
end

```

Note that this works because there's a forced convention between the flight and seat tables. For example, the seat table must have a flight_id field. This way, the seats belonging to the flight exist as a property of @flight:

```
@flight = Flight.find(params[:id])
@seats = @flight.seats
```

Of course, this relationship doesn't have to exist. You can also get the seats for the flight through a query:

```
@seats = Seat.where(:flight_id => params[:id])
```


# Routes

[http://guides.ruby-china.org/routing.html](http://guides.ruby-china.org/routing.html)

## Configuration

```
config/route.rb
```

## Default Route

```
root 'welcome#index'
```

## Connect Route to Controller

```
// example/com/index will map to index_controller.rb's index method
get 'index', to: 'index#index'
```

## URL Parameters

```
get 'blog/:id', to: 'blog#id'
```

## REST Routes

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

#### Declare Multiple REST Routes at Once
```
resources :photos, :books, :videos
```

#### Specify Controller
```
resources :photos, controller: 'images'
```

## Controller Namespace

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


## Remove Namespace Prefix

As above, how to access the corresponding admin/user_controller.rb using [http://192.168.33.10:3000/user](http://192.168.33.10:3000/user)?

```
scope module: 'admin' do
    resources :user
end
```
Or:

```
resources :user, module: 'admin'
```

## Route Mapping to Action in Namespace

Access article_controller.rb using [http://192.168.33.10:3000/admin/articles](http://192.168.33.10:3000/admin/articles).
```
scope '/admin' do
    resources :articles
end
```
Or:
```
resources :articles, path: '/admin/articles'
```


## REST Nested Resources

The relationship between articles and article comments can be represented in the Model like this:
```
class Articles < ActiveRecord::Base
  has_many :comments
end

class Comments < ActiveRecord::Base
  belongs_to :articles
end
```
Similarly, this relationship can be reflected in routes:
```
resources :articles do
    resources :comments
end
```

You can access articles using [http://192.168.33.10:3000/articles](http://192.168.33.10:3000/articles); use [http://192.168.33.10:3000/articles/10/comments](http://192.168.33.10:3000/articles/10/comments) to access comments for an article.


# Controller

## Controller Base Class
Rails controllers all inherit from ApplicationController, which inherits from ActionController::Base
```
class ArticlesController < ApplicationController

end
```
## Parameter Filter

```
class ArticlesController < ApplicationController
  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
```

Specify Parameter Type
```
// Specify id must be an array
params.permit(id: [])
```

Nested Parameters
```
params.permit(:name, { emails: [] },hobbies: [] }])

```

# Rails Validators

Rails validators are tools for checking data validity. Typically we validate data submitted from views in the controller layer, but Rails validators validate data at the model layer. Before executing **.save** or **.update_attributes** operations in the controller layer, validators automatically run.

To use in the model, add rules. For example, to require a field to be a number:

```
class Article < ApplicationRecord
  validates_numericality_of :author_uid
end
```

## Display Error Messages

When validation fails, the page should return to the form submission page, not jump to the data details page. This is normal. However, when a validator fails, the controller needs to know the model wasn't saved. How?

```
if @article.save
    redirect_to "/article/#{@article.id}"
else
    render :template => "articles/new"
```

Of course, the articles/new template's <form> needs to have a field to display errors:

<%=f.error_message%>

## Other Validators:

```
// Validate required field
validates_presence_of :field_name
// Validate length
validates_presence_of :field_name, :maximum=>32
// Validate using regular expression
validates_format_of :field_name, :with=>/regular
// Check if data already exists in the table
validates_uniqueness_of :field_name
// Check if field has a given value
validates_inclusion_of :field_name, :in=>[value1, value2]

```

## Skip Validators

```
model.save(false)
model.update_attributes(false)
```


## Custom Validators

```
class Seat < ApplicationRecord
def validator
    if(baggage > 100)
        errors.add_to_base("Your baggage is too heavy!")
    end
end
end
```


[MORE](https://github.com/ruby-china/rails-guides/blob/master/source/CN/active_record_validations_callbacks.textile)


# Exception

## Default 500 and 404 Templates

public/500.html


# Log

Log File Directory

```
log/development.log
# --
log/test.log
```

## Filter Logs

Filter Specific Request Parameters
```
config.filter_parameters << :password
```

# Security

## Force HTTPS Protocol

```
force_ssl
```
Set Isolation
```
force_ssl only: :cheeseburger
# or
force_ssl except: :cheeseburger
```


## HTTP Authentication

#### Basic Authentication
```
http_basic_authenticate_with name: "xuwenzhi", password: "111111", except: [:index, :show]
```

#### Digest Authentication

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


# Database Query Builder

Suppose there's a data table article with title, content, and other fields. Now there's a search feature that needs to find data by title. We can use the database query builder provided by Rails:

```
@articles = Article.find_all_by_title(params[:search_string])
```

Now, what if we also need to search by content?

```
@articles = Article.find(:all, :conditions => ["title = ? OR content => ?",  params[:search_string], pamras[:search_string]])
```


# Session

## Ways to Store Sessions in Rails

- ActionDispatch::Session::CookieStore: All data stored on the client

- ActionDispatch::Session::CacheStore: Data stored in Rails cache

- ActionDispatch::Session::ActiveRecordStore: Uses Active Record to store data in database (requires activerecord-session_store gem)

- ActionDispatch::Session::MemCacheStore: Data stored in Memcached cluster (this is the old implementation; now use CacheStore instead)


## Default Mode

CookieStore

## Configuration File

config/initializers/session_store.rb

```
# Be sure to restart your server when you modify this file.

# Associated cookie name
# The :domain key can specify which domains can use this cookie
Rails.application.config.session_store :cookie_store, key: '_newblog_session', domain: ".example.com"

```

## Cookie Secret Key

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

## Session Get/Create/Delete

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


> To delete session data, set the key's value to nil. To delete cookie values, use cookies.delete(:key) method.

## Flash

> Flash is a special part of the session that is cleared with each request. This means data stored there can only be used in the next request, useful for passing error messages.

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

## Configuration File

config/initializers/cookies_serializer.rb

> Rails also provides signed and encrypted cookies for storing sensitive data. Signed cookies append a signature to the cookie value to ensure it hasn't been modified. Encrypted cookies sign and encrypt data so end users cannot read it.

```
# Be sure to restart your server when you modify this file.

Rails.application.config.action_dispatch.cookies_serializer = :json
```
1. :json
2. :marshal
3. :hybrid: When reading, Rails will automatically deserialize cookies serialized with Marshal. When writing, it uses JSON format.


## Custom Serialization Mode

```
# MyCustomSerializer needs to define load and dump methods
Rails.application.config.action_dispatch.cookies_serializer = MyCustomSerializer
```

## Cookie Create/Delete

```
// set
cookie[:key] = value

// delete
cookie.delete(:key)
```


# JSON vs. Marshal

[shilov/redis_json_marshal_eval_benchmarks.rb](https://gist.github.com/shilov/1691428)


# Reference

[Rails Practice](https://www.gitbook.com/book/liwei78/rails-practice/details)


