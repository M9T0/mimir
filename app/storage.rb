require "sqlite3"
require "sequel"

class Storage
    def initialize
        @db = Sequel.sqlite("data.db", {:encoding => "utf8"})

        @db.create_table? :sites do
            primary_key :id
            String :title
            String :url
            Date :last_updated
        end

        @db.create_table? :articles do
            primary_key :id
            foreign_key :site_id
            String :title
            String :url
            String :body
        end
    end

    def add(site)
        sites = @db[:sites]
        sites.insert(:title=>site['title'],
                     :url=>site['url'])
    end

    def insert(article)
        articles = @db[:articles]
        articles.insert(:title => article['title'],
                        :url => article['link'],
                        :body => article['body'])
    end

    def sites
        @db[:sites]
    end

    def articles
        @db[:articles]
    end
end

