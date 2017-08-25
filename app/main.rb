#coding:utf-8

require "rss"
require "yaml"

require "httpclient"
require "sinatra"
require "hamlit"

require './storage'

def refresh
    storage = Storage.new

    data = storage.sites

    data.each do |row|
        client = HTTPClient.new

        res = client.get(row["url"])
        feed = RSS::Parser.parse(res.body)
        feed.items.each do |item|
            storage.insert(item)
        end
    end
end

get "/" do
    refresh

    storage = Storage.new
    @feeds = storage.articles

    haml :index 
end

get "/refresh" do
    refresh
end

post "/add" do
    storage = Storage.new

    storage.add({:title=>params[:title],
                 :url=>params[:url]})

    @feeds = storage.articles

    haml :index 
end
