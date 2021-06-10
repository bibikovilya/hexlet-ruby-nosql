require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'mongoid'
  gem 'pry'
end

Mongoid.configure do |config|
  config.clients.default = {
    hosts: ['localhost:27017'],
    database: 'books',
    options: {
      user: 'root',
      password: 'password'
    }
  }

  config.log_level = :warn
end

class Book
  include Mongoid::Document

  field :title, type: String
  field :year, type: Integer, default: 2000

  belongs_to :author
end

class Author
  include Mongoid::Document

  field :name, type: String

  has_many :books
end

author.books

binding.pry
