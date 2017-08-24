#coding:utf-8

require "rss"
require "yaml"

require "httpclient"
require "sinatra"
require "hamlit"

get "/" do
    data = YAML.load(File.read('list.yaml'))

    data.each do |row|
        client = HTTPClient.new

        res = client.get(row["url"])
        feed = RSS::Parser.parse(res.body)
        @feed = feed.items
    end

    haml :index 
end

