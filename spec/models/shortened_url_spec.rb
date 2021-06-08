# frozen_string_literal: true

require 'rails_helper'

describe ShortenedUrl, type: :model do
  fixtures :shortened_urls

  let(:destination_url) { 'https://example.ru' }
  let(:default_params) do
    { url: destination_url }
  end

  context 'validates' do
    subject { described_class.new url_params }

    let(:url_params) { default_params }

    it { is_expected.to be_valid }

    context 'when the unique key is not unique' do
      let(:old_url) { shortened_urls(:example_ru) }
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
end
