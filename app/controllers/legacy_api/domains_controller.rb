# frozen_string_literal: true

module LegacyAPI
  class DomainsController < BaseController

    before_action :find_domain, only: [:destroy, :update, :check]

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

    def destroy
      @domain.destroy
      render_success(message: "DomainDeleted")
    end

    def update
      if @domain.update(safe_params)
        render_success(domain_attributes(@domain))
      else
        render_parameter_error(@domain.errors.full_messages)
      end
    end

    def check
      if @domain.check_dns(:manual)
        render_success(domain_attributes(@domain))
      else
        render_error("InvalidDNS", domain_attributes(@domain))
      end
    end

    private

    def find_domain
      @domain = @current_credential.server.domains.find_by_name(api_params["name"])
      return render_parameter_error("DomainNotFound") unless @domain
    end

    def domain_attributes(domain)
      domain.slice(:id, :uuid, :name, :server_id, :verification_method, :created_at, :updated_at, :dns_checked_at, :owner_id, :owner_type, :spf_record, :spf_status, :spf_error, :dkim_record_name,
                   :dkim_record, :dkim_status, :dkim_error, :mx_status, :mx_error, :return_path_domain, :return_path_status, :return_path_error)
    end

    def safe_params
      params.require(:domain).permit(:name, :verification_method, :owner_id, :owner_type)
    end
  end
end
