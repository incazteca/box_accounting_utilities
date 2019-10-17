# frozen_string_literal: true

require_relative 'lib/chase_transaction_converter'
require_relative 'lib/target_transaction_converter'

input_file = $ARGV[0]
bank = $ARGV[1]

case bank
when 'target'
  TargetTransactionConverter.new(input_file).call
when 'chase'
  ChaseTransactionConverter.new(input_file).call
else
  puts 'Provide a proper bank (chase|target)'
end
