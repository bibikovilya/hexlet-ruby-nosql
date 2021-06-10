require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'activerecord'
  gem 'dotenv'
  gem 'pg'
  gem 'pry'
  gem 'faker'
end

require 'active_record'
require 'dotenv'

db_config = Dotenv.load('pg.env')
DB_FORCE = true # recreate db tables 

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  host: "localhost",
  username: db_config['POSTGRES_USER'],
  password: db_config['POSTGRES_PASSWORD'],
  database: db_config['POSTGRES_DB']
)

ActiveRecord::Schema.define do
  self.verbose = true

  create_table :books, if_not_exists: true, force: DB_FORCE do |t|
    t.string :title
    t.belongs_to :author
    t.jsonb :meta
  end

  create_table :authors, if_not_exists: true, force: DB_FORCE do |t|
    t.string :name
  end
end

class Book < ActiveRecord::Base
  belongs_to :author
end

class Author < ActiveRecord::Base
  has_many :books
end

AUTHORS_COUNT = 10
BOOKS_COUNT = 3..5
META_FIELDS = {
  year: -> { Faker::Number.within(range: 1900..Date.current.year) },
  publisher: -> { Faker::Book.publisher },
  genres: -> { (rand(1..5)).times.map { Faker::Book.genre }},
  published: -> { Faker::Boolean.boolean }
}

AUTHORS_COUNT.times do
  author = Author.create(name: Faker::Book.author)

  rand(BOOKS_COUNT).times do
    meta_count = rand(1..META_FIELDS.keys.count)
    meta_keys = META_FIELDS.keys.sample(meta_count)
    meta_data = meta_keys.each_with_object({}) {|key, hash| hash[key] = META_FIELDS[key].call }

    Book.create(author: author, title: Faker::Book.title, meta: meta_data)
  end
end

Book.where("meta ? :key", key: 'publisher').select("meta->'publisher' as publisher").map(&:publisher)
Author.where(id: Book.where("meta->>'year' > ?", '2000').pluck(:author_id)).pluck(:name)
Book.where("jsonb_array_length(meta->'genres') > ?", 2).pluck(:meta)

binding.pry