require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Results", type: :request do
  path "/result" do
    get "get ongoing bet results" do
      tags "Results#index"
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
          contestant: room.active_match.sorted_contestants.first
        )
      end

      response '200', 'response received' do
        schema type: :object,
          properties: {
            results: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  name: { type: :string },
                  bet: { type: :string },
                },
                required: %w(name bet)
              }
            },
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
            match_id: { type: :string },
          },
          required: %w(results contestants match_id)

        it 'succeeds with a 200 and the current round bets' do |example|
          submit_request(example.metadata)

          assert_response_matches_metadata(example.metadata)
          expect(response.status).to eq(200)

          expect(response_json[:results]).to match_array([
            { name: 'active player', bet: "contestant 1" },
            { name: 'player 1', bet: "contestant 1" },
            { name: 'player 2', bet: "contestant 2" },
          ])
          expect(response_json[:contestants]).to match_array([
            { id: room.active_match.sorted_contestants.first.id, name: 'contestant 1' },
            { id: room.active_match.sorted_contestants.second.id, name: 'contestant 2' },
          ])
          expect(response_json[:match_id]).to eq room.active_match.id
        end
      end
    end
  end
end
