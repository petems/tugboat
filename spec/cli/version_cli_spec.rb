require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'version' do
    it 'shows the correct version' do
      cli.options = cli.options.merge(version: true)

      expect { cli.version }.to output("Tugboat #{Tugboat::VERSION}\n").to_stdout
    end
  end
end
