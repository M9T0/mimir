#coding:utf-8

require "rss"
require "yaml"

require "httpclient"
require "sinatra"
require "hamlit"

require './storage'

def refresh
    storage = Storage.new

    sites = storage.sites

    client = HTTPClient.new
    sites.each do |site|
        res = client.get(site[:url])
        feed = RSS::Parser.parse(res.body)
        feed.items.each do |item|
            if (site[:last_updated] == nil || item.pubDate > site[:last_updated]) then
                storage.insert(item)
            end
        end
    end
    sites.update(:last_updated => Time.now)
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

    puts params
    storage.add({:title=>params["title"],
                 :url=>params["url"]})

    @feeds = storage.articles

    haml :index 
end
