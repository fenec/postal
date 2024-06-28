# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Legacy Domains API", type: :request do
  describe "/api/v1/domains#destroy" do
    context "when the credential is valid" do
      let(:server) { create(:server) }
      let(:credential) { create(:credential, server: server) }
      let!(:domain) { create(:domain, owner: server, name: "example.com") }

      def request
        delete "/api/v1/domains",
             headers: { "x-server-api-key" => credential.key,
                        "content-type" => "application/json" },
             params: { name: "example.com" }.to_json
      end

      it "deletes the domain" do
        request
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["data"]["message"]).to eq("DomainDeleted")
        expect { domain.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
