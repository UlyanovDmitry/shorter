# frozen_string_literal: true

require 'rails_helper'

describe ShortenedUrlsController, type: :controller do
  render_views
  fixtures :shortened_urls

  describe '#POST /urls' do
    let(:destination_url) { 'https://example.ru' }
    let(:params) { { url: destination_url } }
    let(:test_host) { 'http://test.host' }

    context 'when new shortened url is valid' do
      before { post :create, params: params }

      context 'when URL is new' do
        let(:destination_url) { 'https://new_host.pro/' }
        let(:last_url) { ShortenedUrl.last.reload }

        it 'returns new shortened URL' do
          expect(response).to have_http_status(:success)
          expect(response.body).to eq("#{test_host}/urls/#{last_url.unique_key}")
        end
      end

      context 'when URL was already shorted' do
        let(:shortened_url) { shortened_urls(:example_ru) }
        let(:destination_url) { shortened_url.url }

        it 'returns old shortened URL' do
          expect(response).to have_http_status(:success)
          expect(response.body).to eq("#{test_host}/urls/#{shortened_url.unique_key}")
        end
      end
    end

    context 'when new shortened url is not valid' do
      let(:destination_url) { 'https://new_host.pro/' }
      let(:old_shortened_url) { shortened_urls(:example_ru) }
      let(:new_shortened_url) do
        ShortenedUrl.new(url: destination_url, unique_key: old_shortened_url.unique_key)
      end

      before do
        allow(ShortenedUrl)
          .to receive(:find_or_initialize_by)
                .with(url: destination_url)
                .and_return(new_shortened_url)
      end

      it 'returns 400 status' do
        post :create, params: params

        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context 'when URL was not send' do
      let(:params) { {} }

      before { post :create, params: params }

      it 'returns 400 status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#GET /urls/:short_url' do
    let(:short_url) { '' }

    subject(:get_request) { get :show, params: { unique_key: short_url } }

    context 'when url exists' do
      let(:shortened_url) { shortened_urls(:example_ru) }
      let(:short_url) { shortened_url.unique_key }

      before { allow(ShortenedUrlShowCounter).to receive(:perform_later) }

      it 'returns full URL' do
        get_request

        expect(response).to have_http_status(:success)
        expect(response.body).to eq('https://example.ru/')
      end

      it 'adds job for increment of usage count' do
        expect(ShortenedUrlShowCounter).to receive(:perform_later).with(short_url)

        get_request
      end
    end

    context 'when url does not exist' do
      let(:short_url) { 'blablablabla' }

      it 'returns 404 status' do
        get_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#GET /urls/:short_url/stats' do
    let(:short_url) { '' }

    before { get :stats, params: { unique_key: short_url } }

    context 'when url exists' do
      let(:shortened_url) { shortened_urls(:example_ru) }
      let(:short_url) { shortened_url.unique_key }

      it 'returns statistic' do
        expect(response).to have_http_status(:success)
        expect(response.body).to eq('10')
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
