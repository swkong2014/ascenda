require "sinatra/reloader"

class ApplicationController < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    configure :production, :development do
        enable :logging
    end
end