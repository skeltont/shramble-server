require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Matches", type: :request do
  path "/end" do
    post "end a match" do
      tags "Matches#end"
      consumes "application/json"
      produces "application/json"
      security [JWT: {}]

      parameter name: 'Authorization', :in => :header, :type => :string

      let(:'Authorization') { "Bearer #{authenticate(player, room)}" }

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
            match: {
              type: :object,
              properties: {
                match_id: { type: :string },
                contestant_id: { type: :string },
              },
              required: %w(match_id, contestant_id)
            }
        },
        required: %w(match)
      }

      let(:room) { FactoryBot.create(:room, :populated, stage: 'ongoing') }
      let(:player) do
        FactoryBot.create(
          :player,
          :with_bet,
          name: 'active player',
          owner: true,
          room: room,
          contestant: room.active_match.sorted_contestants.first,
        )
      end

      let(:params) {
        {
          match: {
            match_id: room.active_match.id,
            contestant_id: room.active_match.sorted_contestants.first.id,
          }
        }
      }

      response '200', 'response received' do
        schema type: :object,
          properties: {
            next_stage: { type: :string },
          },
          required: %w(next_stage)

        it 'succeeds with a 200 and the current round standings' do |example|
          expect{
            submit_request(example.metadata)
          }.to change{
            room.reload.stage
          }.from('ongoing').to('results')

          assert_response_matches_metadata(example.metadata)

          expect(response_json[:next_stage]).to eq 'results'

          match = room.matches.first
          expect(match.stage).to eq 'inactive'
          expect(match.results.count(&:win?)).to eq 2
          expect(match.winnings).to eq 3

          expect(player.results.first.win?).to eq true

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
