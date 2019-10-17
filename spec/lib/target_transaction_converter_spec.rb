# frozen_string_literal: true

require_relative '../../lib/target_transaction_converter'

RSpec.describe TargetTransactionConverter do
 subject(:target_transaction_converter) { described_class.new(test_file) }
  let(:test_file) { 'spec/fixtures/target_transactions_sample.csv' }

  it 'initializes' do
    expect(target_transaction_converter.transactions).to be_empty
    expect(target_transaction_converter.input_filename).to eq test_file
  end

  describe '#parse_transactions!' do
    let(:expected_transactions) do
      [
        {
          'Date' => '2019-10-11',
          'Store' => 'Target NORRIDGE',
          'Original Amount' => -5.31
        },
        {
          'Date' => '2019-10-08',
          'Store' => 'Target CHICAGO BRICK',
          'Original Amount' => 80.13
        },
        {
          'Date' => '2019-10-05',
          'Store' => 'Target NORRIDGE',
          'Original Amount' => 101
        },
        {
          'Date' => '2019-10-03',
          'Store' => 'Target NORRIDGE',
          'Original Amount' => 25.78
        },
        {
          'Date' => '2019-10-01',
          'Store' => 'Target CHICAGO BRICK',
          'Original Amount' => 47.85
        },
        {
          'Date' => '2019-10-01',
          'Store' => 'Target',
          'Original Amount' => -149.45
        }
      ]
    end

    it 'parses transactions' do
      expect(target_transaction_converter.transactions).to be_empty
      target_transaction_converter.parse_transactions!
      expect(target_transaction_converter.transactions).to eq expected_transactions
    end
  end
end
