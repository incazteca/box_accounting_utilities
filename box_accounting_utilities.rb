# frozen_string_literal: true

require 'pry'
require_relative 'lib/chase_transaction_converter'
require_relative 'lib/target_transaction_converter'
require_relative 'lib/discover_transaction_converter'

def determine_bank(file_name)
  return 'target' if file_name.match?(/Transactions_20\d*_\d*.csv/)
  return 'chase' if file_name.match?(/Chase\d{4}_Activity20\d*_\d*_\d*.CSV/)
  return 'discover' if file_name.match?(/Discover-Statement-20\d*.csv/)
end

def main(input_files)
  transactions = []
  input_files.each do |input_file|
    bank = determine_bank(input_file)
    transactions += case bank
                    when 'target'
                      target = TargetTransactionConverter.new(input_file)
                      target.parse_transactions!
                      target.transactions
                    when 'chase'
                      chase = ChaseTransactionConverter.new(input_file)
                      chase.parse_transactions!
                      chase.transactions
                    when 'discover'
                      discover = DiscoverTransactionConverter.new(input_file)
                      discover.parse_transactions!
                      discover.transactions
                    else
                      puts "Couldn't determine what bank #{input_file} belonged to"
                    end
  end

  # For now to get the work done
  converter = TransactionConverter.new(nil)
  converter.transactions = transactions
  converter.generate_output_csv
end

main($ARGV)
