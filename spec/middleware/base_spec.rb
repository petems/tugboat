require 'spec_helper'

describe Tugboat::Middleware::Base do
  include_context 'spec'

  let(:klass) { described_class }

  describe '.initialize' do
    it 'prints a clear line' do
      expect($stdout).to receive(:print).with('')
      klass.new({})
    end
  end
end
