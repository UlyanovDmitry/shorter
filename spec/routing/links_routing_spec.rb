require 'rails_helper'

describe 'routes for ShortenedUrls', type: :routing do
  context 'when use admin routes' do
    context 'when post request' do
      subject { post('admin/links') }

      it 'routes to the create method' do
        expect(subject)
          .to route_to('admin/links#create')
      end
    end

    context 'when stats request' do
      subject { get('admin/links/abc/stats') }

      it 'routes to the statistic method' do
        expect(subject)
          .to route_to(controller: 'admin/links', action: 'stats', unique_key: 'abc')
      end
    end
  end

  context 'when urls get request' do
    subject { get('links/abc') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to(controller: 'links', action: 'show', unique_key: 'abc')
    end
  end
end
