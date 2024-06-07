require 'rails_helper'

describe LinksController, type: :controller do
  render_views
  fixtures :links

  describe '#POST /links' do
    let(:destination_url) { 'https://example.ru' }
    let(:params) { { url: destination_url } }
    let(:test_host) { 'http://test.host' }

    context 'when new shortened url is valid' do
      before { post :create, params: }

      context 'when URL is new' do
        let(:destination_url) { 'https://new_host.pro/' }
        let(:last_url) { Link.last.reload }

        it 'returns new shortened URL' do
          expect(response).to have_http_status(:success)
          expect(response.parsed_body).to include(url: "#{test_host}/links/#{last_url.unique_key}")
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
          expect(response.parsed_body).to include(url: "#{test_host}/links/#{shortened_url.unique_key}")
        end
      end
    end

    context 'when new shortened url is not valid' do
      let(:destination_url) { 'https://new_host.pro/' }
      let(:old_shortened_url) { links(:example_ru) }
      let(:new_shortened_url) do
        Link.new(url: destination_url, unique_key: old_shortened_url.unique_key)
      end

      before do
        allow(Link)
          .to receive(:find_or_initialize_by)
          .and_return(new_shortened_url)
      end

      it 'returns 400 status' do
        post(:create, params:)

        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body).to include(message: 'Unique key has already been taken')
      end
    end

    context 'when URL was not send' do
      let(:params) { {} }

      before { post :create, params: }

      it 'returns 400 status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#GET /links/:short_url' do
    let(:short_url) { '' }

    subject(:get_request) { get :show, params: { unique_key: short_url } }

    context 'when url exists' do
      let(:shortened_url) { links(:example_ru) }
      let(:short_url) { shortened_url.unique_key }

      before { allow(ClickCounter).to receive(:perform_later) }

      it 'redirect to original url' do
        get_request

        expect(response).to have_http_status(:redirect)
      end

      it 'adds job for increment of usage count' do
        expect(ClickCounter).to receive(:perform_later).with(short_url)

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

  describe '#GET /links/:short_url/stats' do
    let(:short_url) { '' }

    before { get :stats, params: { unique_key: short_url } }

    context 'when url exists' do
      let(:shortened_url) { links(:example_ru) }
      let(:short_url) { shortened_url.unique_key }

      it 'returns statistic' do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include(url_key: shortened_url.unique_key, count: '10')
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