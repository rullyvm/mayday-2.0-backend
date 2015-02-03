# spec/support/fake_github.rb
require 'sinatra/base'

class FakeNationBuilder < Sinatra::Base

  get '/api/v1/lists/?per_page=100' do
    json_response 200, 'lists.json'
  end

  put '/api/v1/people/push' do
    json_response 200, 'people.json'
  end

  get '/api/v1/people/match?email=%s' do
    json_response 200, 'person.json'
  end

  post '/api/v1/sites/mayday/pages/events/%s/rsvps' do
    json_response 200, 'create_rsvp.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end