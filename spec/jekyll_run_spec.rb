require 'jekyll'
require_relative '../lib/jekyll_run'

RSpec.describe(Jekyll) do
  include described_class

  let(:config) { instance_double(Configuration) }
  let(:context) {
    context_ = instance_double(Liquid::Context)
    context_.config = config
    context_
  }

  it 'is created properly' do
    run_tag = RunTag.new('run', 'echo asdf')
    output = run_tag.render(context)
    expect(output).to eq('asdf')
  end
end
