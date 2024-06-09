require 'rails_helper'

RSpec.describe 'Admin::LinksController', type: :request do
  fixtures :links, :users

  let(:user) { users(:admin) }

  before { sign_in(user) }

  describe 'POST /create' do
    let(:destination_url) { 'https://example.ru' }
    let(:params) { { url: destination_url } }
    let(:test_host) { 'http://www.example.com' }

    before { post('/admin/links', params:) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    context 'when URL is new' do
      let(:destination_url) { 'https://new_host.pro/' }
      let(:last_url) { Link.last.reload }

      it 'returns new shortened URL' do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(destination_url: destination_url)
      end

      context 'when URL has not ascii characters' do
        let(:destination_url) { 'https://example.ру' }

        it 'returns new shortened URL' do
          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when URL was already shorted' do
      let(:shortened_url) { links(:example_ru) }
      let(:destination_url) { 'https://example.ru' }

      it 'returns old shortened URL' do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(destination_url: destination_url)
      end
    end

    context 'when URL was not send' do
      let(:params) { {} }

      it 'returns 400 status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /stats' do
    let(:shortened_url) { links(:example_ru) }
    let(:short_url) { shortened_url.unique_key }

    before { get "/admin/links/#{short_url}" }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    context 'when url does not exist' do
      let(:short_url) { 'blablablabla' }

      it 'returns 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
