/**
 * @description       : This is interface class for Price Book.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public interface IPriceBookCreator {

/**
* @description:This method is Used Create Price Book For All Group.
* @param  mapOfCustomer: get the All Group Map of Price List Object.
* @param  priceBookbyCustomer: get the value of Customer from Price Book Object.
* @param  priceList: Valueof Price List Object.
* @param  ontrigger: to Check wheather called from trigger or Not.
* @param  jsPriceBook: Field mapping of Price Book from Custom Meta Data.
* @param  jsPriceBookEntry: Field mapping of Price Book Entry from Custom Meta Data
* @param  discount: to Check either discount or not.
* @return void
*/   

void createPricebook(Map<String,Price_List__c> mapOfCustomer, Map<String,Pricebook2> priceBookbyCustomer,List<Price_List__c> priceList,String ontrigger,String jsPriceBook,String jsPriceBookEntry,boolean discount);       

}