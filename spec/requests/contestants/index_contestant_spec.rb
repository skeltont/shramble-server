require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Contestants", type: :request do
  path "/contestant" do
    get "get match contestants" do
      tags "Contestants#index"
      consumes "application/json"
      produces "application/json"
      security [JWT: {}]

      parameter name: 'Authorization', :in => :header, :type => :string

      let(:'Authorization') { "Bearer #{authenticate(player, room)}" }

      let(:room) { FactoryBot.create(:room, :populated) }
      let(:player) do
        FactoryBot.create(
          :player,
          name: 'active player',
          room: room
        )
      end

      response '200', 'response received' do
        schema type: :object,
          properties: {
            contestants: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :string },
                  name: { type: :string },
                },
                required: %w(id name)
              }
            },
            match_id: { type: :string }
          },
          required: %w(contestants match_id)

        it 'succeeds with a 200 and the current round standings' do |example|
          submit_request(example.metadata)

          assert_response_matches_metadata(example.metadata)
          expect(response.status).to eq(200)

          contestants = room.active_match.sorted_contestants

          expect(response_json[:contestants]).to match_array([
            { id: contestants.first.id, name: contestants.first.name },
            { id: contestants.second.id, name: contestants.second.name },
          ])
          expect(response_json[:match_id]).to eq room.active_match.id
        end
      end
    end
  end
end
