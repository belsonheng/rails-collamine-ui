class Cache
  include Mongoid::Document

  store_in collection: "html"

  field :url, type: String
  field :domain, type: String
  field :source, type: String
  field :content, type: String
  field :crawled_date, type: Integer
  field :response_time, type: Integer
end
