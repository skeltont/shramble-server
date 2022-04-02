require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Matches", type: :request do
  path "/match" do
    post "create a match" do
      tags "Matches#create"
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
                stake: { type: :string, format: :decimal },
                contestants: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: { type: :string },
                    },
                    required: %w(name)
                  }
                },
              },
              required: %w(stake)
            }
        },
        required: %w(match)
      }

      let(:player) { FactoryBot.create(:player, name: 'active player', owner: true, room: room) }
      let(:room) { FactoryBot.create(:room,) }

      let(:params) {
        {
          match: {
            stake: 2.5,
            contestants: [
              { name: 'Lightning McQueen' },
              { name: 'Tow Mater' },
              { name: 'Sanic' },
            ],
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
          expect{submit_request(example.metadata)}.to change{room.matches.count}.from(0).to(1)

          assert_response_matches_metadata(example.metadata)

          expect(response_json[:next_stage]).to eq 'betting'
          match = room.active_match
          expect(match.contestants.count).to eq 3
          expect(match.wager).to eq 2.5

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
