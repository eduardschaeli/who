require 'rubygems'
require 'sinatra/base'
require 'rack/cors'
require 'json'
require './Scan.rb'

class Who < Sinatra::Base

  use Rack::Cors do |config|
    config.allow do |allow|
      allow.origins '*'
      allow.resource '/', headers: :any, methods: :get
      allow.resource '/*',
        methods: [:get, :post, :put, :delete],
        headers: :any,
        max_age: 0
    end
  end

  get '/' do
    content_type :json
    Scan.load_from_textfile
    out = {clients_in_db: Scan.all.size, last_scan: Scan.last_scan, in_office: []}

    active_users = Scan.find_active_users
    if active_users.size > 0
      active_users.each do |user|
        out[:in_office] << {
          name: user[:name],
          hostname: user[:hostname],
          ip: user[:ip],
          mac: user[:mac],
          state: user[:state]
        }
      end
    end

    out.to_json
  end

  # HTML version
  # ------------
  #
  # get '/' do
  #   Scan.load_from_textfile
  #   out = ""
  #   out += "<h1>Who's in the office?</h1>"
  #   out += "<h2>Last scan: #{Scan.last_scan}</h2>"
  #   out += "<h2>Network clients in DB: #{Scan.all.size}</h2>"
  #   active_users = Scan.find_active_users

  #   if active_users.size > 0
  #     active_users.each do |user|
  #       out += "<ul>"
  #       out += "<li><strong>#{user[:name]}</strong></li>"
  #       out += "<li>#{user[:hostname]}</li>"
  #       out += "<li>#{user[:ip]}</li>"
  #       out += "<li>#{user[:mac]}</li>"
  #       out += "<li>#{user[:state]}</li>"
  #       out += "</ul>"
  #     end
  #   else
  #     out += "Nobody is in the office... :("
  #   end


  #   "<html><body>#{out}</body></html>"
  # end
end
