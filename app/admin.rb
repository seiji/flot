module Flot
  class Admin < Sinatra::Base
    enable :sessions
    register Sinatra::Namespace

    set :public_folder, "public"
    set :views, "app/views/admin"

    set :sprockets, Sprockets::Environment.new

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = '/assets'
      config.digest = true
      sprockets.append_path 'app/assets/javascripts'
      sprockets.append_path 'app/assets/stylesheets'
    end

    helpers Sprockets::Helpers
 
    get '/' do
      haml :"index"
    end

    get '/crawls' do
      @crawls = Crawl.all.sort("created_at" => -1)
      @active = 'crawls'
      haml :"crawls"
    end

    get '/crawls/:feed_url' do |feed_url|
      @active = 'crawls'
      @crawls = Crawl.where(:feed_url => feed_url).sort("created_at" => -1)
      haml :"crawl"
    end

    get '/feeds' do
      @active = 'feeds'
      @feeds = Feed.all.sort("last_modified" =>  -1)
      haml :"feeds"
    end

    get '/feeds/:feed_url' do |feed_url|
      @active = 'feeds'
      @feed = Feed.where(:feed_url => feed_url).first
      haml :"feed"
    end

    get '/entries' do
      @active = 'entries'
      @entries = Entry.all.sort("published" =>  -1)
      haml :"entries"
    end

    get '/users' do
      @active = 'users'
      @users = User.all.sort("updated_at" =>  -1)
      haml :"users"
    end
  end
end
