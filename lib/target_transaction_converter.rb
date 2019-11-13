# frozen_string_literal: true
# typed: true

require 'csv'
require 'date'
require_relative 'transaction_converter'

# TargetTransactionConverter, used for converting transactions for Target CC to
# a CSV we can use for box accounting
class TargetTransactionConverter < TransactionConverter
  # Bring the `sig` method into scope
  extend T::Sig

  AMOUNT_REGEX = /\d+.\d{2}/.freeze

  sig{returns(T::Array[T::Hash[String,String]])
  def parse_transactions!
    CSV.foreach(@input_filename, converters: :numeric, headers: true) do |row|
      next if row['Reference Number'].nil?

      transactions << process_row(row)
    end
  end

  private

  sig {params(row: CSV::Row).returns(T::Hash[String, String])}
  def process_row(row)
    transaction_date = Date.strptime(row['Trans Date'], US_DATE_FORMAT)
    amount_parsed = AMOUNT_REGEX.match(row['Amount'])[0].to_f
    amount = row['Type'] == 'Debit' ? amount_parsed : -amount_parsed

    {
      'Date' => transaction_date.strftime(UTC_DATE_FORMAT),
      'Store' => "Target #{row['Merchant City']}".strip,
      'Original Amount' => amount
    }
  end
end
