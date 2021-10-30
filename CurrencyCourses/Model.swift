//
//  Model.swift
//  CurrencyCourses
//
//  Created by Рамазан Нуриев on 29.09.2021.
//

import UIKit

/*
 <NumCode>826</NumCode>
 <CharCode>GBP</CharCode>
 <Nominal>1</Nominal>
 <Name>‘ÛÌÚ ÒÚÂÎËÌ„Ó‚ —ÓÂ‰ËÌÂÌÌÓ„Ó ÍÓÓÎÂ‚ÒÚ‚‡</Name>
 <Value>43,8254</Value>
 */


class Currency {
    var NumCode: String?
    var CharCode: String?
    
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    
    var Value : String?
    var valueDouble: Double?
    
    class func rouble () -> Currency {
        let r = Currency()
        r.CharCode = "RUR"
        r.Name = "Российский рубль"
        r.Nominal = "1"
        r.nominalDouble = 1
        r.Value = "1"
        r.valueDouble = 1
        return r
    }
    
}

class Model: NSObject, XMLParserDelegate {
    
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        
        let d = ( (fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!) ) * amount!
        
        return String(d)
        
    }
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        if FileManager.default.fileExists(atPath: path){
            return path
        }
        
       
        return Bundle.main.path(forResource: "data", ofType: "xml")!
        
    }
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
        
    }
    
    //загрузка XML с sbr.ru и сохранение его в каталоге приложения
    //http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002
    func loadXMLFile(date:Date?) {
        
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            strUrl = strUrl+dateFormatter.string(from: date!)
        }
        
        let url = URL(string: strUrl)
        
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            var errorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: urlForSave)
                  
                    print("Файл загружен")
                    self.parseXML()
                } catch {
                    print("Error when save data:\(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
                
            } else {
                print("Error when loadXMLFile:"+error!.localizedDescription )
                errorGlobal = error?.localizedDescription
            }
             
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLloading"), object: self, userInfo: ["ErrorName": errorGlobal])
            }
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        task.resume()
        
    }
    
    //распарсить Xml и положить его в currencies: [Currency], отправить уведомление приложению о том что данные обновились
    func parseXML()  {
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print ("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        
        for c in currencies {
            if c.CharCode == fromCurrency.CharCode{
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode{
                toCurrency = c
            }
        }
        
        
    }
    
    var currentCurrency: Currency?
     
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
            currentDate = currentDateString
            }
        } 
       
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
            
    }
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string

        
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        /*
         <NumCode>826</NumCode>
         <CharCode>GBP</CharCode>
         <Nominal>1</Nominal>
         <Name>‘ÛÌÚ ÒÚÂÎËÌ„Ó‚ —ÓÂ‰ËÌÂÌÌÓ„Ó ÍÓÓÎÂ‚ÒÚ‚‡</Name>
         <Value>43,8254</Value>
         */
        if elementName == "NumCode" {
            currentCurrency?.NumCode = currentCharacters
        }
        if elementName == "CharCode" {
            currentCurrency?.CharCode = currentCharacters
        }
        if elementName == "Nominal" {
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters .replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name" {
            currentCurrency?.Name = currentCharacters
        }
        if elementName == "Value" {
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
        
    }

  
}
 
