require "./spec/spec_helper"
require "json"

describe 'The Word Counting App' do
  def app
    Sinatra::Application
  end

  describe 'get' do
    it "returns 200 and has the right keys(for text from file)" do
      get '/'
      expect(last_response).to be_ok
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response).to have_key("text")
      expect(parsed_response).to have_key("exclude")
      expect(parsed_response).to have_key("client_id")
    end

    it "returns 200 and has the right keys(for random text generated)" do
      get '/random'
      expect(last_response).to be_ok
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response).to have_key("text")
      expect(parsed_response).to have_key("exclude")
      expect(parsed_response).to have_key("client_id")
    end
  end

  describe 'post' do
    it "returns 200 if frequency count correct" do
      post '/', {text: "Call me Ishmael", exclude: ["Ishmael"], freq_count: {"Call": 1, "Me": 1}, client_id: 10}.to_json
      expect(last_response).to be_ok 
    end
    
    it "returns 400 if frequency count is wrong" do
      post '/', {text: "Call me Ishmael", exclude: ["Ishmael"], freq_count: {"Call": 2, "Me": 1}, client_id: 10}.to_json
      expect(last_response).to be_a_bad_request 
    end
    
    it "returns 400 if bad request made" do
      post '/', {text: "Call me Ishmael", exclude: "jjdhds", freq_count: {"Call": 2, "Me": 1}, client_id: 10}.to_json
      expect(last_response).to be_a_bad_request 
    end
    
    it "returns 400 if message already exists" do
      post '/', {text: "quia nobis laborum aliquid alias aliquam quia.", exclude: ["quia.","laborum","aliquid","aliquam"], freq_count: {"quia": 1, "nobis": 1, "alias": 1}, client_id: 50536}.to_json
      expect(last_response).to be_a_bad_request 
    end
  end

end
