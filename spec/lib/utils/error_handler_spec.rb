require 'rails_helper'

RSpec.describe Utils::ErrorHandler do
  include described_class

  describe '#handle_resource_error' do
    let(:resource) { double(errors: double(full_messages: ['Resource error'])) }
    let(:error_message) { 'An error occurred' }

    it 'logs the error and message' do
      expect(logger).to receive(:error).with('StandardError - An error occurred: Resource error')

      handle_resource_error(resource, error_message)
    end
  end

  describe '#log_error' do
    let(:error) { StandardError.new('Custom error') }
    let(:error_message) { 'Error message' }

    it 'logs the provided error and message' do
      expect(logger).to receive(:error).with('StandardError - Error message: Custom error')

      log_error(error, error_message)
    end
  end
end
