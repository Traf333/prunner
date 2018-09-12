require_relative '../../lib/prunner'
require_relative '../factory'

RSpec.describe Prunner do
  include Factory

  describe '#call' do
    let(:indicator) { build_indicator }
    let(:category) { build_category('indicators' => [indicator, build_indicator]) }
    let(:sub_theme) { build_sub_theme('categories' => [category, build_category]) }
    let(:theme) { build_theme('sub_themes' => [sub_theme]) }
    let(:tree) { [theme, build_theme] }
    let(:client) { double('client', tree: Result.new(tree)) }
    let(:indicator_ids) { [indicator['id']] }

    before do
      allow(subject).to receive(:client) { client }
    end

    it 'returns origin tree without passed ids' do
      result = subject.call
      expect(result).to be_success
      expect(result.value).to eq tree
    end

    it 'returns prunned tree result' do
      result = subject.call(indicator_ids)
      expect(result).to be_success
      expect(result.value).to eq [theme]

      sub_themes = result.value.first['sub_themes']
      expect(sub_themes).to eq [sub_theme]

      categories = sub_themes.first['categories']
      expect(categories).to eq [category]

      indicators = categories.first['indicators']
      expect(indicators).to eq [indicator]
    end

    context 'client has external error' do
      let(:client) { double('client', tree: Result.error(:external_error)) }

      it 'returns result with error message' do
        expect(subject.call).not_to be_success
      end
    end
  end
end
