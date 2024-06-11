require 'rails_helper'

describe LinksController, type: :controller do
  render_views
  fixtures :links

  describe '#GET /links/:short_url' do
    let(:short_url) { '' }

    subject(:get_request) { get :show, params: { unique_key: short_url } }

    context 'when url exists' do
      let(:shortened_url) { links(:example_ru) }
      let(:short_url) { shortened_url.unique_key }
      let(:click_logger) { double(ClickRedisImport) }

      it 'adds job for increment of usage count' do
        expect(ClickRedisImport).to receive(:new).and_return(click_logger)
        expect(click_logger).to receive(:call).and_return(true)

        get_request

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
