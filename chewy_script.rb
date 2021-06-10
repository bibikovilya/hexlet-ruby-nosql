require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'activerecord'
  gem 'dotenv'
  gem 'pg'
  gem 'pry'
  gem 'faker'

  gem 'chewy'
end

require 'active_record'
require 'dotenv'

db_config = Dotenv.load('pg.env')
DB_FORCE = true # recreate db tables 

Chewy.strategy(:atomic)

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
  end

  create_table :authors, if_not_exists: true, force: DB_FORCE do |t|
    t.string :name
  end
end

class Book < ActiveRecord::Base
  update_index('books') { self }

  belongs_to :author
end

class Author < ActiveRecord::Base
  has_many :books
end

class BooksIndex < Chewy::Index
  index_scope Book
  field :title
end

AUTHORS_COUNT = 10
BOOKS_COUNT = 3..5

AUTHORS_COUNT.times do
  author = Author.create(name: Faker::Book.author)

  rand(BOOKS_COUNT).times do
    Book.create(author: author, title: Faker::Book.title)
  end
end

BooksIndex.import
BooksIndex.query(query_string: {query: 'a'}).records

binding.pry