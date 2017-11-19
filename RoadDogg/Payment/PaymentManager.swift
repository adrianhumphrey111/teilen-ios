//
//  File.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/15/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import Stripe
import Alamofire


class PaymentManager {

    
    // Get the default Realm
    static let shared = PaymentManager()
    
    private let apiVersion = "2017-08-15"
    
    private let baseURL = "https://teilen-ride.com/api/"
    
    var customerContext : STPCustomerContext!
    
    var paymentContext : STPPaymentContext!
    
    
    init(){
        // Setup customer context
        self.customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        
        //Setup Payment context
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
    }
    
    func requestCharge(amount: Int){
        Network.shared.chargeRider(amount: amount).then { result -> Void in
            //print(result) //Handle the response and update ui
            
            
/*
             ["invoice": <null>, "amount_refunded": 0, "source": {
             "address_city" = "<null>";
             "address_country" = "<null>";
             "address_line1" = "<null>";
             "address_line1_check" = "<null>";
             "address_line2" = "<null>";
             "address_state" = "<null>";
             "address_zip" = "<null>";
             "address_zip_check" = "<null>";
             brand = Visa;
             country = US;
             customer = "cus_BmXFdJ6q2XRV7q";
             "cvc_check" = pass;
             "dynamic_last4" = "<null>";
             "exp_month" = 10;
             "exp_year" = 2021;
             fingerprint = EG1L2FwQOvN52Sjx;
             funding = debit;
             id = "card_1BOyDBBc4uJ9t9j5JMwBal7v";
             last4 = 1918;
             metadata =     {
             };
             name = "<null>";
             object = card;
             "tokenization_method" = "<null>";
             }, "fraud_details": {
             }, "refunds": {
             }, "outcome": {
             "network_status" = "approved_by_network";
             reason = "<null>";
             "risk_level" = normal;
             "seller_message" = "Payment complete.";
             type = authorized;
             }, "amount": 50, "paid": 1, "failure_message": <null>, "application": <null>, "refunded": 0, "source_transfer": <null>, "id": ch_1BOyKmBc4uJ9t9j5rZZZ3iVL, "currency": usd, "receipt_email": <null>, "transfer_group": <null>, "receipt_number": <null>, "shipping": <null>, "metadata": {
             "transaction_key" = "Key('Transaction', 5652786310021120)";
             }, "object": charge, "description": <null>, "customer": cus_BmXFdJ6q2XRV7q, "application_fee": <null>, "success": 1, "status": succeeded, "captured": 1, "destination": <null>, "created": 1510880876, "statement_descriptor": <null>, "on_behalf_of": <null>, "review": <null>, "livemode": 1, "dispute": <null>, "balance_transaction": txn_1BOyKnBc4uJ9t9j57REiIOl2, "order": <null>, "failure_code": <null>]
 
        */
        }
        
    }
    
    
    
    
}
