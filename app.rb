require "sinatra"
require "redis"
require "json"
require "dotenv/load"

redis = Redis.new(url: ENV["REDIS_URL"])

set :bind, '0.0.0.0'
set :default_content_type, :json

before do
    halt 401, 'Unauthorized' unless request.env["HTTP_AUTHORIZATION"] == ENV["AUTH_HEADER"]
end

get "/" do
    keys = redis.keys "*"
    puts keys

    key_values = keys.each_with_object({}) do |key, hash|
        value = JSON.parse redis.get(key)

        puts value

        hash[key] =  value
    end

    puts key_values
    key_values.to_json
end

get "/:key" do
    redis.get params["key"]
end

post "/:key" do
    request.body.rewind
    redis.set params["key"], request.body.read
    status 200
end

delete "/:key" do
    redis.del(params["key"])
    status 200
end
