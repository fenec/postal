# frozen_string_literal: true

module LegacyAPI
  class DomainsController < BaseController

    def create
      server = @current_credential.server
      domain = server.domains.build(
        name: api_params["name"],
        verification_method: "DNS",
        verified_at: Time.current
      )
      if domain.save
        render_success(domain_attributes(domain))
      else
        render_parameter_error(domain.errors.full_messages)
      end
    end

    def check
      domain = @current_credential.server.domains.find_by_name(api_params["name"])
      return render_parameter_error("DomainNotFound") unless domain

      if domain.check_dns(:manual)
        render_success(domain_attributes(domain))
      else
        render_error("InvalidDNS", domain_attributes(domain))
      end
    end

    private

    def domain_attributes(domain)
      domain.slice(:id, :uuid, :name, :server_id, :verification_method, :created_at, :updated_at, :dns_checked_at, :owner_id, :owner_type, :spf_record, :spf_status, :spf_error, :dkim_record_name,
                   :dkim_record, :dkim_status, :dkim_error, :mx_status, :mx_error, :return_path_domain, :return_path_status, :return_path_error)
    end

  end
end
