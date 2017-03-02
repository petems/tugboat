require 'spec_helper'

describe Tugboat::Middleware::FindImage do
  include_context 'spec'

  describe '.call' do
    it 'raises SystemExit with no image data' do
      expect { described_class.new(app).call(env) }.to raise_error(SystemExit)

      expect($stdout.string).to include 'Tugboat attempted to find an image with no arguments'
      expect($stdout.string).to include 'For more help run: '
      expect($stdout.string).to include 'Try running `tugboat '
    end
  end
end
