# frozen_string_literal: true

require_relative 'lib/chase_transaction_converter'

input_file = $ARGV[0]

ChaseTransactionConverter.new(input_file).call
