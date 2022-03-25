require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Results", type: :request do
  path "/result"  do
    get "get ongoing bet results" do
      tags "Results#index"
      consumes "application/json"
      produces "application/json"

      expected_response_schema = {
        type: :object,
        properties: {
          id: { type: :integer },
          title: { type: :string },
          body: { type: :string }
        },
        required: [ 'id', 'title', 'body' ]
      }

      let(:player) { FactoryBot.create(:player) }

      response '200', 'response received' do
        before do |example|
          submit_request(example.metadata)
        end

        it 'returns a valid 200 response' do |example|
          puts '#####'
          puts player.name
          puts '#####'
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
