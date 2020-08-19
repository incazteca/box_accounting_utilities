# frozen_string_literal: true

require 'csv'
require 'date'
require_relative 'transaction_converter'

# DiscoverTransactionConverter, used for converting transactions for Discover CC to
# a CSV we can use for box accounting
class DiscoverTransactionConverter < TransactionConverter
  AMOUNT_REGEX = /\d+.\d{2}/.freeze

  def parse_transactions!
    CSV.foreach(@input_filename, converters: :numeric, headers: true) do |row|
      transactions << process_row(row)
    end
  end

  private

  def process_row(row)
    transaction_date = Date.strptime(row['Trans. Date'], US_DATE_FORMAT)

    {
      'Date' => transaction_date.strftime(UTC_DATE_FORMAT),
      'Store' => row['Description'],
      'Original Amount' => row['Amount']
    }
  end
end
