require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#bootstrap_alert_class' do
    it 'returns the appropriate class for success key' do
      result = helper.bootstrap_alert_class('success')
      expect(result).to eq('alert alert-success alert-dismissible fade show')
    end

    it 'returns the appropriate class for alert key' do
      result = helper.bootstrap_alert_class('alert')
      expect(result).to eq('alert alert-warning alert-dismissible fade show')
    end

    it 'returns the appropriate class for error key' do
      result = helper.bootstrap_alert_class('error')
      expect(result).to eq('alert alert-danger alert-dismissible fade show')
    end

    it 'returns the default class for other keys' do
      result = helper.bootstrap_alert_class('other_key')
      expect(result).to eq('alert alert-info alert-dismissible fade show')
    end
  end
end
