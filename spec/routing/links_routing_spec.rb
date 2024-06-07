require 'rails_helper'

describe 'routes for ShortenedUrls', type: :routing do
  context 'when post request' do
    subject { post('/links') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to('links#create')
    end
  end

  context 'when urls get request' do
    subject { get('/links/abc') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to(controller: 'links', action: 'show', unique_key: 'abc')
    end
  end

  context 'when stats request' do
    subject { get('/links/abc/stats') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to(controller: 'links', action: 'stats', unique_key: 'abc')
    end
  end
end
