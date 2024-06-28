# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Legacy Domains API", type: :request do
  describe "/api/v1/domains#update" do
    context "when the credential is valid" do
      let(:server) { create(:server) }
      let(:credential) { create(:credential, server: server) }
      let!(:domain) { create(:domain, owner: server, name: "example.com") }

      def request
        put "/api/v1/domains",
             headers: { "x-server-api-key" => credential.key,
                        "content-type" => "application/json" },
             params: { name: "example.com", domain: { name: "example1.com" } }.to_json
      end

      context "when update data is valid" do
        it "updates the domain" do
          request
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["status"]).to eq("success")
          expect(domain.reload.name).to eq("example1.com")
        end
      end

      context "when update data is valid" do
        def invalid_request
          put "/api/v1/domains",
               headers: { "x-server-api-key" => credential.key,
                          "content-type" => "application/json" },
               params: { name: "example.com", domain: { name: "" } }.to_json
        end

        it "returns error" do
          invalid_request
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["status"]).to eq("parameter-error")
          expect(parsed_body["data"]["message"][0]).to eq("Name can't be blank")
        end
      end
    end
  end
end
