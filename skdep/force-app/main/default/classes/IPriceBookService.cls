/**
 * @description       : This is interface class for Price Book service class to createPrice Book.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public Interface IPriceBookService {

/** 
* @Description - This method is Used Call Different Classes based on PriceList Data. 
* @param List :priceList,String-Ontrigger.
* @return  -    void
*/           
void createPriceBookAndEntries(List<Price_List__c> priceList,String ontrigger);

}