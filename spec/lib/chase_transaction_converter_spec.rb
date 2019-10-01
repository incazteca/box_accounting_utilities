# frozen_string_literal: true

require_relative '../../lib/chase_transaction_converter'

RSpec.describe ChaseTransactionConverter do
  subject(:chase_transaction_converter) { described_class.new(test_file) }
  let(:test_file) { 'spec/fixtures/chase_transactions_sample.csv' }

  it 'initializes' do
    expect(chase_transaction_converter.transactions).to be_empty
    expect(chase_transaction_converter.input_filename).to eq test_file
  end

  describe '#parse_transactions!' do
    let(:expected_transactions) do
      [
        {
          'Date' => '2019-09-23',
          'Store' => '2986 Dominos Pizza',
          'Original Amount' => 13.21
        },
        {
          'Date' => '2019-09-22',
          'Store' => 'KFC G135532',
          'Original Amount' => 27.27
        },
        {
          'Date' => '2019-09-21',
          'Store' => 'THE HOME DEPOT 1903',
          'Original Amount' => -5.48
        },
        {
          'Date' => '2019-09-20',
          'Store' => 'SHELL OIL 57444352801',
          'Original Amount' => 51.78
        },
        {
          'Date' => '2019-09-15',
          'Store' => 'Payment Thank You - Web',
          'Original Amount' => -94.52
        },
        {
          'Date' => '2019-09-12',
          'Store' => 'STARBUCKS',
          'Original Amount' => 20.00
        },
        {
          'Date' => '2019-09-11',
          'Store' => "MCDONALD'S F1581",
          'Original Amount' => 15.28
        },
        {
          'Date' => '2019-09-10',
          'Store' => 'ROTI MEDITERRANEAN GRILL',
          'Original Amount' => 38.23
        },
        {
          'Date' => '2019-09-08',
          'Store' => 'POTBELLY #98',
          'Original Amount' => 34.31
        }
      ]
    end

    it 'parses transactions' do
      expect(chase_transaction_converter.transactions).to be_empty
      chase_transaction_converter.parse_transactions!
      expect(chase_transaction_converter.transactions).to eq expected_transactions
    end
  end
end
