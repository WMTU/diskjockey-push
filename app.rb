require 'sinatra'
require 'yaml'

# Load configuration settings
CONFIG = YAML.load_file('config.yml')
puts CONFIG.inspect

class DiskjockeyPush < Sinatra::Base
  post '/update' do
    if params["api_secret"] && params["api_secret"] == CONFIG["API_SECRET"]
      # Get info from the post data
      artist = params[:artist]
      track = params[:track]
      album = params[:album]
      logged_at = params[:logged_at]

      # Run command to update whatever
      command = %W(ls -al #{artist} #{track} #{album} #{logged_at})

      process = IO.popen(command)
      Process.wait()

      # If we returned 0 send 200 else 500
      if $?.exitstatus == 0
        status 200
      else
        status 500
      end
    else
      status 401
    end
  end
end
