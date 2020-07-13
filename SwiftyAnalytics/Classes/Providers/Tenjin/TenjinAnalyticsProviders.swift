//
//  TenjinAnalyticsProviders.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 3/25/20.
//

open class TenjinAnalyticsProviders: AnalyticsProviable {
    
    public init(apiToken: String) {
        TenjinSDK.`init`(apiToken)
        TenjinSDK.connect()
    }
    
    open func log(event name: String, parameters: [String:Any]?) {
        
//        if let parameters = parameters,
//            let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
//            let json = String(data: data, encoding: .utf8) {
//            
//            TenjinSDK.sendEvent(withName: name, andEventValue: json)
//            return
//        }
        
        TenjinSDK.sendEvent(withName: name)
    }
    
    open func log(iap transaction: SKPaymentTransaction, product: SKProduct, receipt: String) {
        TenjinSDK.transaction(
            withProductName: product.productIdentifier,
            andCurrencyCode: product.priceLocale.currencyCode,
            andQuantity: 1,
            andUnitPrice: product.price,
            andTransactionId: transaction.transactionIdentifier,
            andBase64Receipt: receipt
        )
    }

}
