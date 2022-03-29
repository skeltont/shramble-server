require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Rooms", type: :request do
  path "/room" do
    get "get room info and current match stage" do
      tags "Rooms#index"
      consumes "application/json"
      produces "application/json"
      security [JWT: {}]

      parameter name: 'Authorization', :in => :header, :type => :string

      let(:'Authorization') { "Bearer #{authenticate(player, room)}" }

      let(:room) { FactoryBot.create(:room, :populated) }
      let(:player) do
        FactoryBot.create(
          :player,
          :with_bet,
          name: 'active player',
          room: room,
          contestant: room.active_match.sorted_contestants.first,
          win: true
        )
      end

      response '200', 'response received' do
        schema type: :object,
          properties: {
            room_id: { type: :string },
            room_code: { type: :string },
            stage: { type: :string },
          },
          required: %w(room_id room_code stage)

        it 'succeeds with a 200 and the current round standings' do |example|
          submit_request(example.metadata)

          assert_response_matches_metadata(example.metadata)
          expect(response.status).to eq(200)

          expect(response_json[:room_id]).to eq room.id
          expect(response_json[:room_code]).to eq room.room_code
          expect(response_json[:stage]).to eq 'pending'
        end
      end
    end
  end
end
