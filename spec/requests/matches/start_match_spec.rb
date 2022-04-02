require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Matches", type: :request do
  path "/start" do
    post "start a match" do
      tags "Matches#start"
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
              },
              required: %w(match_id)
            }
        },
        required: %w(match)
      }

      let(:player) { FactoryBot.create(:player, name: 'active player', owner: true, room: room) }
      let(:room) { FactoryBot.create(:room, :populated, stage: 'betting') }

      let(:params) {
        {
          match: {
            match_id: room.active_match.id,
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
          expect{submit_request(example.metadata)}.to change{room.reload.stage}.from('betting').to('ongoing')

          assert_response_matches_metadata(example.metadata)
          expect(response_json[:next_stage]).to eq 'ongoing'

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
