require 'spec_helper'

describe Tugboat::Middleware::InjectClient do
  include_context 'spec'

  let(:tmp_path) { project_path + '/tmp/tugboat' }

  before do
    config = Tugboat::Configuration.instance
    env['config'] = config
  end

  describe '.call' do
    it 'loads the client into the environment' do
      described_class.new(app).call(env)

      expect(env['barge']).to be_a Barge::Client
    end

    it 'creates a client with values from config file' do
      expect(Barge::Client).to receive(:new).with(hash_including(access_token: 'foo'))

      described_class.new(app).call(env)
    end
  end
end
