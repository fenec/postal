# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Legacy Domains API", type: :request do
  describe "/api/v1/domains#create" do
    context "when the credential is valid" do
      let(:server) { create(:server) }
      let(:credential) { create(:credential, server: server) }

      def request
        post "/api/v1/domains",
             headers: { "x-server-api-key" => credential.key,
                        "content-type" => "application/json" },
             params: { name: "example.com" }.to_json
      end

      context "when Domain is valid" do
        it "creates a new domain" do
          expect { request }.to change { Domain.count }.by(1)
        end

        it "returns domain's data hash" do
          request
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["data"]["name"]).to eq("example.com")
        end
      end

      context "when Domain already exists" do
        let!(:existing_domain) { create(:domain, owner: server, name: "example.com") }

        it "returns a error" do
          request
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["status"]).to eq("parameter-error")
          expect(parsed_body["data"]["message"][0]). to eq("Name is already added")
        end
      end
    end
  end
end
