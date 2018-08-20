require 'spec_helper'

describe 'RSpec::Puppet::ManifestMatchers.include_class' do
  subject(:matcher) { Class.new { extend RSpec::Puppet::ManifestMatchers }.include_class(expected) }

  def test_double(type, *args)
    if respond_to?(:instance_double)
      instance_double(type, *args)
    else
      double(type.to_s, *args)
    end
  end

  let(:actual) do
    lambda { test_double(Puppet::Resource::Catalog, :classes => included_classes) }
  end

  let(:expected) { 'test_class' }
  let(:included_classes) { [] }

  it { is_expected.not_to be_diffable }

  describe '#description' do
    it 'includes the expected class name' do
      expect(matcher.description).to eq("include Class[#{expected}]")
    end
  end

  describe '#matches?' do
    context 'when the catalogue includes the expected class' do
      let(:included_classes) { [expected] }

      it 'returns true' do
        expect(matcher.matches?(actual)).to be_truthy
      end
    end

    context 'when the catalogue does not include the expected class' do
      let(:included_classes) { ['something_else'] }

      it 'returns false' do
        expect(matcher.matches?(actual)).to be_falsey
      end
    end
  end

  describe '#failure_message_for_should', :if => rspec2? do
    it 'provides a description and the expected class' do
      matcher.matches?(actual)
      expect(matcher.failure_message_for_should).to eq("expected that the catalogue would include Class[#{expected}]")
    end
  end

  describe '#failure_message', :unless => rspec2? do
    it 'provides a description and the expected class' do
      matcher.matches?(actual)
      expect(matcher.failure_message).to eq("expected that the catalogue would include Class[#{expected}]")
    end
  end

  describe '#failure_message_for_should_not', :if => rspec2? do
    let(:included_classes) { [expected] }

    it 'provides a description and the expected class' do
      pending 'not implemented'
      matcher.matches?(actual)
      expect(matcher.failure_message_when_negated).to eq("expected that the catalogue would not include Class[#{expected}]")
    end
  end

  describe '#failure_message_when_negated', :unless => rspec2? do
    let(:included_classes) { [expected] }

    it 'provides a description and the expected class' do
      pending 'not implemented'
      matcher.matches?(actual)
      expect(matcher.failure_message_when_negated).to eq("expected that the catalogue would not include Class[#{expected}]")
    end
  end
end
