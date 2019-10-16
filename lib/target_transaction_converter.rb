# frozen_string_literal: true

require 'csv'
require 'date'
require 'bigdecimal'

# TargetTransactionConverter, used for converting transactions for Target CC to
# a CSV we can use for box accounting
class TargetTransactionConverter
  US_DATE_FORMAT = '%m/%d/%Y'
  UTC_DATE_FORMAT = '%Y-%m-%d'
  OUTPUT_FILE_NAME = 'transactions.csv'
  AMOUNT_REGEX = /\d+.\d{2}/.freeze

  attr_reader :transactions, :input_filename

  def initialize(filename)
    @input_filename = filename
    @transactions = []
  end

  def call
    parse_transactions!
    generate_output_csv
  end

  def parse_transactions!
    CSV.foreach(@input_filename, converters: :numeric, headers: true) do |row|
      next if row['Reference Number'].nil?

      transactions << process_row(row)
    end
  end

  def generate_output_csv
    CSV.open(OUTPUT_FILE_NAME, 'wb') do |row|
      row << transactions.first.keys
      transactions.each { |t| row << t.values }
    end
  end

  private

  def process_row(row)
    transaction_date = Date.strptime(row['Trans Date'], US_DATE_FORMAT)
    amount_parsed = BigDecimal((AMOUNT_REGEX.match row['Amount'])[0])
    amount = row['Type'] == 'Debit' ? amount_parsed : -amount_parsed

    {
      'Date' => transaction_date.strftime(UTC_DATE_FORMAT),
      'Store' => "Target #{row['Merchant City']}".strip,
      'Original Amount' => amount
    }
  end
end
