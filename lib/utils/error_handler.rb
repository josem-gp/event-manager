module Utils
  module ErrorHandler
    def set_flash_errors(object)
      flash.now[:alert] = object.errors.full_messages
    end
  end
end
