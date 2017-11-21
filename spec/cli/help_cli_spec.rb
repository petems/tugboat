require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'help' do
    it 'shows a help message' do
      expected_string = %r{To learn more or to contribute, please see}
      expect { cli.help }.to output(expected_string).to_stdout
    end

    it 'shows a help message for specific commands' do
      expected_string = %r{Show available droplet sizes}
      expect { cli.help 'sizes' }.to output(expected_string).to_stdout
    end
  end
end
