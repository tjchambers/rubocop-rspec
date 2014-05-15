# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::RSpecInstanceVariable do
  subject(:cop) { described_class.new }

  it 'finds an instance variable inside describe block' do
    inspect_source(cop, ['describe MyClass do',
                         '  before { @foo = [] }',
                         '  it { expect(@foo).to be_emtpy }',
                         'end'])
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([3])
    expect(cop.messages).to eq(['Use `let` instead of an instance variable'])
  end

  it 'ignores an instance variable without describe' do
    inspect_source(cop, ['@foo = []',
                         '@foo.empty?'])
    expect(cop.offenses).to be_empty
  end
end
