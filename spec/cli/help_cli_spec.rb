require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'help' do
    it 'shows a help message' do
      @cli.help
      expect($stdout.string).to match('Commands:')
    end

    it 'shows a help message for specific commands' do
      @cli.help 'sizes'
      expect($stdout.string).to match('Usage:')
    end
  end
end
