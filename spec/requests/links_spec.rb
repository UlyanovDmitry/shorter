require 'rails_helper'

RSpec.describe 'LinksControllers', type: :request do
  fixtures :links

  describe 'GET /links/:short_url' do
    let(:short_url) { '' }

    before { get "/links/#{short_url}" }

    context 'when url exists' do
      let(:shortened_url) { links(:example_ru) }
      let(:short_url) { shortened_url.unique_key }

      before { allow(ClickCounter).to receive(:perform_later) }

      it 'redirect to original url' do
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when url does not exist' do
      let(:short_url) { 'blablablabla' }

      it 'returns 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
