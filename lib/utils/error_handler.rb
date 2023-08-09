module Utils
  module ErrorHandler
    def flash_errors(resource)
      flash.now[:validation_error] = resource.errors.full_messages
    end

    def handle_resource_error(resource, message)
      error_message = resource.errors.full_messages.join(', ')
      log_error(StandardError.new(error_message), message)
    end

    def log_error(error, message)
      logger.error("#{error.class.name.demodulize} - #{message}: #{error.message}")
    end

    def logger
      Rails.logger
    end
  end
end
