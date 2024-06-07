require 'rails_helper'

describe ClickCounter do
  fixtures :links

  describe '#perform' do
    subject { described_class.new.perform params }

    let(:params) { nil }

    context 'when params has short url from DB' do
      let(:shortened_url) { links(:example_ru) }
      let(:params) { shortened_url.unique_key }

      it 'updates use_count of shortened_url' do
        expect { subject }
          .to change { shortened_url.reload.use_count }.from(10).to(11)
          .and(change { shortened_url.reload.updated_at })
      end
    end
  end
end
