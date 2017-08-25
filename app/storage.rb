require "sqlite3"
require "sequel"

class Storage
    def initialize
        @db = Sequel.sqlite("data.db", {:encoding => "utf8"})

        @db.create_table? :sites do
            primary_key :id
            String :title
            String :url
            Time :last_updated
        end

        @db.create_table? :articles do
            primary_key :id
            foreign_key :site_id
            String :title
            String :url
            String :body
            Time :published
        end
    end

    def add(site)
        sites = @db[:sites]
        sites.insert(:title=>site[:title],
                     :url=>site[:url])
    end

    def insert(article)
        articles = @db[:articles]
        articles.insert(:title => article.title,
                        :url => article.link,
                        :body => article.description,
                        :published => article.pubDate)
    end

    def sites
        @db[:sites]
    end

    def articles
        @db[:articles].order(Sequel.desc(:published))
    end
end

