# frozen_string_literal: true

require_relative '../chase_transaction_converter'

RSpec.describe ChaseTransactionConverter do
  subject(:chase_transaction_converter) { described_class.new(test_file) }
  let(:test_file) { 'spec/chase_transactions_sample.csv' }

  it 'initializes' do
    expect(chase_transaction_converter.transactions).to be_empty
    expect(chase_transaction_converter.input_filename).to eq test_file
  end
end
