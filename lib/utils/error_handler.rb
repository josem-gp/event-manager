module Utils
  module ErrorHandler
    def flash_errors(object)
      flash.now[:alert] = object.errors.full_messages
    end
  end
end
