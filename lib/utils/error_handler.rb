module Utils
  module ErrorHandler
    def flash_errors(object)
      flash.now[:alert] = object.errors.full_messages
    end

    def logger
      Rails.logger
    end
  end
end
