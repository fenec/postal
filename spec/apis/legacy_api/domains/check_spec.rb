# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Legacy Domains API", type: :request do
  describe "/api/v1/domains#check" do
    context "when the credential is valid" do
      let(:server) { create(:server) }
      let(:credential) { create(:credential, server: server) }
      let!(:domain) { create(:domain, owner: server, name: "example.com") }

      def request
        post "/api/v1/domains/check",
             headers: { "x-server-api-key" => credential.key,
                        "content-type" => "application/json" },
             params: { name: "example.com" }.to_json
      end

      context "when domain's DNS check is sucessful" do
        it "returns domain's data hash" do
          allow_any_instance_of(Domain).to receive(:check_dns).and_return(true)
          request

          parsed_body = JSON.parse(response.body)

          attributes = [:id, :uuid, :name, :server_id, :verification_method, :created_at, :updated_at, :dns_checked_at, :owner_id, :owner_type, :spf_record, :spf_status, :spf_error, :dkim_record_name,
                        :dkim_record, :dkim_status, :dkim_error, :mx_status, :mx_error, :return_path_domain, :return_path_status, :return_path_error,].map(&:to_s)

          expect(attributes.all? { |attribute| parsed_body["data"].key?(attribute) }).to eq(true)
        end
      end

      context "when domain's DNS check is not sucessful" do
        it "returns a error" do
          request
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["data"]["code"]).to eq "InvalidDNS"
        end
      end
    end
  end
end
