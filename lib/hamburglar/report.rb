module Hamburglar
  # The Hamburglar::Report is the main class for generating fraud
  # reports
  class Report
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    # Get or set required parameters for this report
    def self.required_params(*params)
      if params.size > 0
        @required_params = params
      else
        @required_params ||= []
      end
    end
  end
end