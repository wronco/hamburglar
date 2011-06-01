module Hamburglar
  # Hamburglar::Report is the main class for generating fraud reports
  class Report
    # Parameters that will be used to generate this fraud report
    attr_reader :params

    def initialize(params = {})
      @gateway = params.delete(:gateway) || Hamburglar.config.gateway
      @params  = params
      @report  = generate_report!
    end

    def method_missing(method, *args, &block)
      if @report[method.to_sym]
        @report[method.to_sym]
      else
        super
      end
    end

    def respond_to?(key)
      @report.has_key?(key) || super
    end
  private

    def generate_report!
      api = gateway.new(@params)
      if api.valid?
        api.submit
      else
        api.errors
      end
    end

    def gateway
      case @gateway.to_s
      when /min_fraud/
        Gateways::MaxMind::MinFraud
      when /telephone/
        Gateways::MaxMind::TelephoneVerification
      else
        raise Hamburglar::InvalidGateway, @gateway
      end
    end

  end
end
