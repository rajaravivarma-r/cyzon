class PaymentGateway

  RESPONSE = 'txn_status=success|amount=10000.00|' \
             'merchant_transaction_ref=txn001|transaction_date=2014-11-14|'\
             'payment_gateway_merchant_reference=merc001|'\
             'payment_gateway_transaction_reference=pg_txn_0001|'\
             'hash=abdedffduedd000000988'
  RIGHT_RESPONSE = 'txn_status=success|amount=10000.00|' \
                   'merchant_transaction_ref=txn001|transaction_date=2014-11-14|'\
                   'payment_gateway_merchant_reference=merc001|'\
                   'payment_gateway_transaction_reference=pg_txn_0001|'\
                   'hash=858310b47ffdd818379943e1f452d45debba7320'
end
