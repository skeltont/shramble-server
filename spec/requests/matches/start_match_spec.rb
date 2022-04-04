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

      response '204', 'response received' do
        it 'succeeds with a 204' do |example|
          expect{
            submit_request(example.metadata)
          }.to change{room.reload.stage}.from('betting').to('ongoing')
           .and have_broadcasted_to("room_#{room.room_code}").with(stage: 'ongoing')

          expect(response.status).to eq(204)
        end
      end
    end
  end
end
