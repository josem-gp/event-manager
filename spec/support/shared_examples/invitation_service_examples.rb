RSpec.shared_examples 'error handling' do |error_class, error_num|
  it "logs the error for #{error_class}" do
    expect(Rails.logger).to receive(:error).with(a_string_matching(/.*#{error_class}.*/)).exactly(error_num).times
    expect(Rails.logger).to receive(:info).with("#{error_num} invitations have thrown an error.")

    invitation_service.call
  end
end
