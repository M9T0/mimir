#coding:utf-8

require "sinatra"
require "hamlit"

get "/" do
    haml :index
end

get "/reload" do
end

get "/feed/:id" do
end
