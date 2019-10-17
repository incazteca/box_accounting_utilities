# frozen_string_literal: true

require 'csv'
require 'date'
require 'bigdecimal'

# TransactionConverter, base class used for converting transactions
class TransactionConverter
  US_DATE_FORMAT = '%m/%d/%Y'
  UTC_DATE_FORMAT = '%Y-%m-%d'
  OUTPUT_FILE_NAME = 'transactions.csv'

  attr_reader :transactions, :input_filename

  def initialize(filename)
    @input_filename = filename
    @transactions = []
  end

  def call
    parse_transactions!
    generate_output_csv
  end

  def generate_output_csv
    CSV.open(OUTPUT_FILE_NAME, 'wb') do |row|
      row << transactions.first.keys
      transactions.each { |t| row << t.values }
    end
  end
end
