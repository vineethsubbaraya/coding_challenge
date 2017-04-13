require 'sinatra'
require "sinatra/reloader" if development?
require 'faker'
require 'json'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'json-schema'
require_relative 'helper/app_helper'

helpers AppHelper

DataMapper.setup :default, "sqlite://#{Dir.pwd}/database.db" if development?
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/database.db") if production?
require_relative 'model/word_count'
DataMapper.auto_upgrade!

get '/' do
  files = %w(texts/0 texts/1 texts/2 texts/3 texts/4 texts/5)

  text_file = files.sample
  source_text = File.read(text_file).strip
  exclude = get_exclude_words(source_text)
  client = WordCount.new(text: source_text.downcase, exclude: exclude.join(","))
  client.save

  status 200
  erb :"get.json", locals: { source_text: source_text, exclude: exclude, client_id: client.client_id }
end

get '/random' do
  text =  Faker::Lorem.sentence
  exclude = get_exclude_words(text)
  client = WordCount.new(text: text.downcase, exclude: exclude.join(","))
  client.save
  
  erb :"get.json", locals: { source_text: text, exclude: exclude, client_id: client.client_id }
end

post '/' do

  data = request.body.read
  schema = {
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "required": ["text", "exclude", "freq_count", "client_id"],
    "properties": {
      "text": {
        "type": "string",
      },
      "exclude": {
        "type": "array",
        "items": {
          "type": "string",
        }
      },
      "freq_count": {
        "type": "object",
        "items": {
          "type": "integer",
        }
      },
      "client_id": {
        "type": "integer",
      }
    }
  }

  begin
    valid = JSON::Validator.fully_validate(schema, data)
    if !valid.empty?
      halt 400, {'Content-Type' => 'application/json'}, { message: 'Invalid Json format' }.to_json
    end
  rescue
    halt 400, {'Content-Type' => 'application/json'}, { message: 'Invalid Json format' }.to_json
  end
  payload = JSON.parse(data)
  original_freq = get_frequencies(payload["text"], payload["exclude"])
  client = WordCount.last(:client_id => payload["client_id"])
  
  

  if check_frequencies(original_freq, payload["freq_count"])
      if check_prev_msg(payload["text"], payload["exclude"], client)
        status 400
        message = "Previous text same!"
      else
        status 200
        message = "Looks great!"
      end
  else
    status 400
    message = "Sorry, that's wrong. Nice try space troll"
  end
  erb :"msg.json", locals: {message: message, status: status, client: client}
end
