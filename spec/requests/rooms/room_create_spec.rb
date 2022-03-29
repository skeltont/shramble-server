require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Rooms", type: :request do
  path "/room" do
    post "create a room" do
      tags "Rooms#create"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
            room: {
              type: :object,
              properties: {
                player_name: { type: :string },
                recaptcha_token: { type: :string },
              },
              required: %w(player_name recaptcha_token)
            }
        },
        required: %w(room)
      }

      let(:player_name) { 'test name' }
      let(:recaptcha_token) { 'token checking is disabled in test thank god' }
      let(:params) {
        {
          room: {
            player_name: player_name,
            recaptcha_token: recaptcha_token,
          }
        }
      }

      response '200', 'response received' do
        schema type: :object,
          properties: {
            token: { type: :string },
            room_id: { type: :string },
            room_code: { type: :string },
            owner: { type: :boolean },
          },
          required: %w(token room_id room_code owner)

        it 'succeeds with a 200 and the current round standings' do |example|
          expect{submit_request(example.metadata)}.to change{Room.all.count}.from(0).to(1)

          assert_response_matches_metadata(example.metadata)

          room = Room.first
          expect(response_json[:room_id]).to eq room.id
          expect(response_json[:room_code]).to eq room.room_code
          expect(response_json[:owner]).to eq true

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
