require 'rails_helper'

describe ClicksImporter do
  fixtures :links

  describe '#perform' do
    let(:event_time) { Time.parse('2024-10-25 08:22:42 UTC') }
    let(:click_data) do
      {
        link_id: links(:example_ru).id,
        ip: '127.0.0.1',
        user_agent: 'Postman v. 1.1.',
        timestamp: event_time.to_i
      }
    end
    subject { described_class.new.perform }

    before { REDIS_CONN_POOL.with { |conn| conn.rpush(ClickRedisImport::REDIS_CLICKS_KEY, click_data.to_json) } }

    it 'moves correct data to clicks' do
      expect { subject }.to change { Click.count }.by(1)

      expect(Click.first.timestamp).to eq(event_time)
    end

    it 'removes data from redis' do
      expect { subject }
        .to change { REDIS_CONN_POOL.with { |conn| conn.llen(ClickRedisImport::REDIS_CLICKS_KEY) } }.to(0)
    end

    context 'when click data count greater than batch' do
      before do
        REDIS_CONN_POOL.with do |conn|
          (ClicksImporter::BATCH_SIZE * 2).times do
            conn.rpush(ClickRedisImport::REDIS_CLICKS_KEY, click_data.to_json)
          end
        end
      end

      it 'imports all data' do
        expect { subject }.to change { Click.count }.by((ClicksImporter::BATCH_SIZE * 2) + 1)
      end

      it 'removes data from redis' do
        expect { subject }
          .to change { REDIS_CONN_POOL.with { |conn| conn.llen(ClickRedisImport::REDIS_CLICKS_KEY) } }.to(0)
      end
    end

    context 'when click import fails with exception' do
      before { allow(Click).to receive(:import).and_raise(StandardError) }

      it 'keeps data in redis' do
        expect(REDIS_CONN_POOL.with { |conn| conn.llen(ClickRedisImport::REDIS_CLICKS_KEY) }).to eq(1)

        expect { subject }.to raise_error(StandardError)

        expect(REDIS_CONN_POOL.with { |conn| conn.llen(ClickRedisImport::REDIS_CLICKS_KEY) }).to eq(1)
      end
    end
  end
end
