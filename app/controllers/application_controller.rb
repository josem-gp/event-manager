class ApplicationController < ActionController::Base
  include Utils::ErrorHandler
  protect_from_forgery with: :exception
end
