require 'rails_helper'

describe 'routes for ShortenedUrls', type: :routing do
  context 'when post request' do
    subject { post('/urls') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to('shortened_urls#create')
    end
  end

  context 'when urls get request' do
    subject { get('/urls/abc') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to(controller: 'shortened_urls', action: 'show', unique_key: 'abc')
    end
  end

  context 'when stats request' do
    subject { get('/urls/abc/stats') }

    it 'routes to the ShortenedUrls controller' do
      expect(subject)
        .to route_to(controller: 'shortened_urls', action: 'stats', unique_key: 'abc')
    end
  end
end
