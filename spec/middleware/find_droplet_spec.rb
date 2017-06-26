require 'spec_helper'

describe Tugboat::Middleware::FindDroplet do
  include_context 'spec'

  describe '.call' do
    it 'raises SystemExit with no droplet data' do
      expect { described_class.new(app).call(env) }.to raise_error(SystemExit).and output(%r{Tugboat attempted to find a droplet with no argument}).to_stdout
      expect { described_class.new(app).call(env) }.to raise_error(SystemExit).and output(%r{For more help run:}).to_stdout
      expect { described_class.new(app).call(env) }.to raise_error(SystemExit).and output(%r{Try running `tugboat}).to_stdout
    end
  end
end
