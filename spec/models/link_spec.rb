require 'rails_helper'

describe Link, type: :model do
  fixtures :links, :users

  let(:destination_url) { 'https://example.ru' }
  let(:default_params) { { url: destination_url, user: users(:admin) } }
  subject { described_class.new url_params }

  describe 'validates' do
    let(:url_params) { default_params }

    it { is_expected.to be_valid }

    context 'when the unique key is not unique' do
      let(:old_url) { links(:example_ru) }
      let(:url_params) { default_params.merge(unique_key: old_url.unique_key) }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.attribute_names).to match_array(:unique_key)
      end
    end

    context 'when the url is blank' do
      let(:destination_url) { '' }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.attribute_names).to match_array(:url)
      end
    end
  end

  context 'when the unique key is generated' do
    let(:url_params) { default_params }

    before { subject.save! }

    it 'generates a unique key' do
      expect(subject.unique_key).to_not be_nil
      expect(subject.unique_key).to_not be_empty
      expect(subject.unique_key.size).to eq(6)
    end
  end
end
