# frozen_string_literal: true

require 'csv'
require 'date'
require_relative 'transaction_converter'

# ChaseTransactionConverter, used for converting transactions for Chase CC to a
# CSV we can use for box accounting
class ChaseTransactionConverter < TransactionConverter
  def parse_transactions!
    CSV.foreach(@input_filename, converters: :numeric, headers: true) do |row|
      transaction_date = Date.strptime(row['Transaction Date'], US_DATE_FORMAT)

      transactions << {
        'Date' => transaction_date.strftime(UTC_DATE_FORMAT),
        'Store' => row['Description'],
        'Original Amount' => -row['Amount'] # Use `-` to capture refunds
      }
    end
  end
end
