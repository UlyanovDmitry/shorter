require 'rails_helper'

RSpec.describe Click, type: :model do
  fixtures :links

  subject { described_class.new params }

  let(:event_time) { Time.parse('2024-06-09 12:29:55 UTC') }

  let(:params) do
    {
      link_id: links(:example_ru).unique_key,
      ip: '127.0.0.1',
      user_agent: 'Postman v1',
      timestamp: event_time.to_i
    }
  end

  it { is_expected.to be_valid }

  it 'sets the timestamp correctly' do
    expect(subject.timestamp).to eq(event_time)
  end
end
