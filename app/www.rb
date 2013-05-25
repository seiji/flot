module Flot
  class WWW < Sinatra::Base
    enable :sessions, :logging

    OmniAuth.config.full_host = lambda do |env|
      scheme         = env['rack.url_scheme']
      local_host     = env['HTTP_HOST']
      forwarded_host = env['HTTP_X_FORWARDED_HOST']
      forwarded_host.blank? ? "#{scheme}://#{local_host}" : "#{scheme}://#{forwarded_host}"
    end
    
    OmniAuth.config.on_failure = Proc.new do |env|
      message_key = env['omniauth.error.type']
      response = Rack::Response.new
      response.write env['omniauth.error'].inspect
      response.finish
    end
    
    OMNIAUTH_YAML = File.join(settings.root, '..', 'private', 'config',  'omniauth.yml')
    OMNIAUTH_CONFIG = YAML.load_file(OMNIAUTH_YAML)["#{settings.environment}"]

#    OmniAuth.config.logger = Rack::Logger
    # move config

    use OmniAuth::Builder do
      provider :google_oauth2, OMNIAUTH_CONFIG['google']['key'], OMNIAUTH_CONFIG['google']['secret'],
      {
        :scope => 'userinfo.email,userinfo.profile,plus.me,http://www.google.com/reader/api'
      }
    end

    set :public_folder, "public"
    set :views, "app/views"

    get '/' do
      haml :"index"
    end

    get '/auth/:name/callback' do
      env['omniauth.auth']
      # @auth = request.env['omniauth.auth']
      #  haml :"index2"
    end
  end
end
