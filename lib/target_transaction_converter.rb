# frozen_string_literal: true

require 'csv'
require 'date'
require 'bigdecimal'
require_relative 'transaction_converter'

# TargetTransactionConverter, used for converting transactions for Target CC to
# a CSV we can use for box accounting
class TargetTransactionConverter < TransactionConverter
  AMOUNT_REGEX = /\d+.\d{2}/.freeze

  def parse_transactions!
    CSV.foreach(@input_filename, converters: :numeric, headers: true) do |row|
      next if row['Reference Number'].nil?

      transactions << process_row(row)
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
