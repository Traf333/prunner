require_relative '../../lib/client'

RSpec.describe Client do

  describe '#tree' do
    let(:stub_response) { double(success?: true) }

    before do
      allow(described_class).to receive(:get) { stub_response }
    end

    it { expect(subject.tree).to eq stub_response }

    context 'failed request' do
      let(:retry_count) { 2 }
      let(:error_message) { 'Something went wrong' }
      let(:stub_response) { double(success?: false, body: error_message) }
      let(:successful_response) { double(success?: true) }

      it 'sets an error message' do
        expect(subject.tree).to be_nil
        expect(subject.error).to eq error_message
      end

      it 'returns response if one of requests was successful' do
        call_count = 0
        allow(subject).to receive(:fetch_tree) do
          call_count += 1
          call_count.odd? ? raise(Client::ExternalError) : successful_response
        end
        expect(subject.tree).to eq successful_response
      end
    end
  end
end
