require_relative '../../lib/client'

RSpec.describe Client do

  describe '#tree' do
    let(:stub_response) { double(success?: true) }

    before do
      allow(described_class).to receive(:get) { stub_response }
    end

    it { expect(subject.tree.value).to eq stub_response }

    context 'failed request' do
      let(:retry_count) { 2 }
      let(:error_message) { 'Something went wrong' }
      let(:stub_response) { double(success?: false, body: error_message) }
      let(:successful_response) { Result.new(double(success?: true)) }

      it 'return error result' do
        result = subject.tree
        expect(result).to be_a Result
        expect(result).not_to be_success
        expect(result.error.data).to eq error_message
      end

      it 'returns response if one of requests was successful' do
        call_count = 0
        allow(subject).to receive(:fetch_tree) do
          call_count += 1
          call_count.odd? ? raise(Client::ExternalError) : successful_response
        end
        result = subject.tree
        expect(result).to be_success
        expect(result).to eq successful_response
      end
    end
  end
end
