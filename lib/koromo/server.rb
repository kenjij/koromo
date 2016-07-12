require 'sinatra/base'
require 'logger'
require 'koromo/config'
require 'koromo/helper'
require 'koromo/sql'

module Koromo

  # The Sinatra server
  class Server < Sinatra::Base

    attr_reader :rack_opts
    # attr_reader :config

    def initialize(opts)
      super()
      @rack_opts = opts
      Koromo.load_config(rack_opts[:config])
    end

    def slogger
      return logger if settings.logging
      @slogger ||= Logger.new(STDOUT)
      return @slogger
    end

    helpers Helper

    configure do
      set :environment, :production
      enable :logging
      disable :static, :dump_errors
    end

    before do
      # @jsonp_callback = params[:callback]
      halt 401 unless valid_token?(params[:auth])
      Koromo.sql.setup(Koromo.config)
    end

    get '/:resource' do |r|
      result = Koromo.sql.get_resource(r, params: params)
      if result
        json_with_object(result)
      else
        fail Sinatra::NotFound
      end
    end

    get '/:resource/:id' do |r, id|
      fail Sinatra::NotFound if /\W/ =~ id
      result = Koromo.sql.get_resource(r, id: id, params: params)
      if result
        json_with_object(result)
      else
        fail Sinatra::NotFound
      end
    end

    not_found do
      json_with_object({message: 'Huh, nothing here.'})
    end

    error 401 do
      json_with_object({message: 'Oops, need a valid auth.'})
    end

    error do
      status 500
      err = env['sinatra.error']
      slogger.error "#{err.class.name} - #{err}"
      json_with_object({message: 'Yikes, internal error.'})
    end

    after do
      content_type 'application/json'
      # if @jsonp_callback
      #   content_type 'application/javascript'
      #   body @jsonp_callback + '(' + json_with_object(@body_object) + ')'
      # else
      #   content_type 'application/json'
      #   body json_with_object(@body_object, {pretty: config[:global][:pretty_json]})
      # end
    end

  end
end
