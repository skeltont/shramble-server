require 'spec_helper'
require 'swagger_helper'

RSpec.describe "Matches", type: :request do
  path "/match/new" do
    get "set the room to accept a new match" do
      tags "Matches#new"
      consumes "application/json"
      produces "application/json"
      security [JWT: {}]

      parameter name: 'Authorization', :in => :header, :type => :string

      let(:'Authorization') { "Bearer #{authenticate(player, room)}" }

      let(:room) { FactoryBot.create(:room) }

      let(:owner) { true }
      let(:player) do
        FactoryBot.create(
          :player,
          name: 'active player',
          room: room,
          owner: owner,
        )
      end

      response '200', 'response received' do
        schema type: :object,
          properties: {
            next_stage: { type: :string },
          },
          required: %w(next_stage)

        it 'succeeds with a 200' do |example|
          submit_request(example.metadata)

          assert_response_matches_metadata(example.metadata)
          expect(response.status).to eq(200)

          expect(response_json[:next_stage]).to eq 'pending'
        end

      end

      response '403', 'error processing request' do
        schema type: :object,
          properties: {
            error: { type: :string },
          },
          required: %w(error)

        context 'when the user is not the owner' do
          let(:owner) { false }

          it 'fails with a 403 and error message' do |example|
            submit_request(example.metadata)

            assert_response_matches_metadata(example.metadata)
            expect(response.status).to eq(403)

            expect(response_json[:error]).to eq 'you are not the owner'
          end
        end
      end
    end
  end
end
