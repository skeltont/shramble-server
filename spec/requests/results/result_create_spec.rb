require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Results", type: :request do
  path "/result" do
    post "create bet for a match" do
      tags "Results#create"
      consumes "application/json"
      produces "application/json"
      security [JWT: {}]

      parameter name: 'Authorization', :in => :header, :type => :string

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
            result: {
              type: :object,
              properties: {
                match_id: { type: :string },
                contestant_id: { type: :string },
              },
              required: %w(match_id contestant_id)
            }
        },
        required: %w(result)
      }

      let(:'Authorization') { "Bearer #{authenticate(player, room)}" }

      let(:room) { FactoryBot.create(:room, :populated) }
      let(:player) do
        FactoryBot.create(
          :player,
          name: 'active player',
          room: room
        )
      end

      let(:match_id) { room.active_match.id }
      let(:contestant_id) { room.active_match.sorted_contestants.first.id }
      let(:params) {
        {
          result: {
            match_id: match_id,
            contestant_id: contestant_id,
          }
        }
      }

      response '200', 'response received' do
        schema type: :object,
          properties: {
            result_id: { type: :string }
          },
          required: %w(result_id)

        it 'succeeds with a 200 and the current round standings' do |example|
          expect{submit_request(example.metadata)}.to change{room.active_match.results.count}.from(2).to(3)

          assert_response_matches_metadata(example.metadata)

          expect(response_json[:result_id]).to eq room.active_match.results.sort_by(&:created_at).last.id

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
