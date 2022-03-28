require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Results", type: :request do
  path "/standings" do
    get "get match round standings" do
      tags "Results#standings"
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
            standings: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  name: { type: :string },
                  winnings: { type: :string, format: :decimal },
                },
                required: %w(name winnings)
              }
            },
          },
          required: %w(standings)

        it 'succeeds with a 200 and the current round standings' do |example|
          submit_request(example.metadata)

          assert_response_matches_metadata(example.metadata)
          expect(response.status).to eq(200)

          expect(response_json[:standings]).to match_array([
            { name: 'player 1', winnings: "-2.0" },
            { name: 'player 2', winnings: "-2.0" },
            { name: 'active player', winnings: "4.0" },
          ])
        end
      end
    end
  end
end
