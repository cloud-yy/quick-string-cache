require "sinatra"
require "redis"
require "json"
require "dotenv/load"

redis = Redis.new(url: ENV["REDIS_URL"])

set :bind, '0.0.0.0'

before do
    halt 401, 'Unauthorized' unless request.env["HTTP_AUTHORIZATION"] == ENV["AUTH_HEADER"]
end

get "/" do
    keys = redis.keys("*")

    keyValues = keys.each_with_object({}) do |key, hash|
      value = redis.get(key)
      hash[key] = value
    end

    keyValues.to_json
end

get "/:key" do
    redis.get(params["key"])
end

delete "/:key" do
    redis.del(params["key"])
end

post "/:key/:value" do
    redis.set(params["key"], params["value"])
end
