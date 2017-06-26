require 'spec_helper'

describe Tugboat::Middleware::Base do
  include_context 'spec'

  let(:klass) { described_class }

  describe '.initialize' do
    it 'prints a clear line' do
      expect { klass.new({}) }.to output('').to_stdout
    end
  end
end
