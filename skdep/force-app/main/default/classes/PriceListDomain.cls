/**
 * @description       : This class Show all Query from Price List Domain Object.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class PriceListDomain extends LibSObjectDomain {
    
    public PriceListDomain(List<Price_List__c> records){
        super(records);
    }
    
    public class Constructor implements LibSObjectDomain.IConstructable {  
        public LibSObjectDomain construct(List<sObject> sObjectList) {
            System.debug('sObjectList List'+sObjectList);
            return new PriceListDomain(sObjectList);    }
    }
    
 
/** 
* @Description - This method is Used Call Main Service Class after update to crete Price book and Entry. 
* @param - map<id, SObject> existing
* @return  -   void
*/           
    public Override void onAfterUpdate(map<id, SObject> existing){
        System.debug('Existing Map is--->'+existing);
        String ontrigger='ontrigger';
        System.debug('After Insert Send Email');
        for(sObject record:(List<Price_List__c>)records)
        {
            Price_List__c pricelist=(Price_List__c)record;        
            if(pricelist.Latest_Update_Status__c=='Open' && pricelist.OnDemand__c==false ){
                System.debug('Go for Batch');  
                System.debug('Value of Lookup is'+pricelist.Customer__r.name);
                PriceBookService x=new PriceBookService();
                x.createPriceBookAndEntries(records,ontrigger);
            }      
        }   
    }
    
/** 
* @Description - This method is Used Call Main Service Class after insert to crete Price book and Entry. 
* @param - map<id, SObject> existing
* @return  -   void
*/  
    
    public Override void onAfterInsert(){
        System.debug('After Insert Send Email');
        String ontrigger='ontrigger';
        for(sObject record:(List<Price_List__c>)records)
        {
            Price_List__c pricelist=(Price_List__c)record;
            
            if(pricelist.Latest_Update_Status__c=='Open' && pricelist.OnDemand__c==false ){
                System.debug('Go for Batch');  
                PriceBookService pbsObj=new PriceBookService();
                pbsObj.createPriceBookAndEntries(records,ontrigger);  
            }      
        }   
    }
}