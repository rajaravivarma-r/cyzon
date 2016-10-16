#!/usr/bin/env ruby

require_relative '../lib/client.rb'

puts("Enter option: ")
puts("\t 1. Test positive scenario (Where the response in intact)")
puts("\t 2. Test negative scenario (Where the response digest doesn't match the hash)")
puts("\t Default -> Test positive scenario (Where the response in intact)")
choice = gets().chomp.to_i
client = Client.new
choices = Hash.new {|h, k| h[k] = lambda { client.request_payment('http://examplepg.com/transaction/1') } }
choices.update({
 2 => lambda { client.request_payment('http://examplepg.com/transaction/2') }
})

choices[choice].call
