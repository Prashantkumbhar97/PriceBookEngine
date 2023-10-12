/**
 * @description       : This Batch Class is used to Create Price book and Entry for Bulk of data.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

global class CreatePriceBookBatch implements Database.Batchable<sObject> {

boolean strParameter=false;

/**
* @description:or of Batch to check checkbox
* @param  strParam: Check the Status wheather it's fire from trigger or Not.
*/   

global CreatePriceBookBatch(boolean strParam) {
    strParameter = strParam;
    System.debug('String parameter is' +strParameter);    
}

/**
* @description:Start Method of Batch to Process and Query on Price List.
* @param  Database.BatchableContext: It's a batch Interface 
* @return Database.QueryLocator
*/    

global Database.QueryLocator start(Database.BatchableContext bc){
    System.debug('In Start Method');
    String status='Open';
    string query;

    LibISObjectSelector selector= Application.selector.newInstance(Price_List__c.sObjectType);
    PriceListSelector selectorObj=(PriceListSelector)selector;
    
    Database.QueryLocator priceListQuery=null;      
    if(strParameter==false){
        priceListQuery=   selectorObj.allPriceList();
    }
    else if(strParameter==True){ 
        priceListQuery=  selectorObj.allPriceListonDemand();    
    }
    return priceListQuery;         
}

/**
* @description:Execute Method to call Service Class.
* @param  Database.BatchableContext: It's a batch Interface 
* @param  priceList: List of Price List Records
* @return void
*/
global void execute(Database.BatchableContext bc, List<Price_List__c> priceList){
    PriceBookService pricebookser=new PriceBookService();
    pricebookser.createPriceBookAndEntries(priceList,'OnBatch');
}

/**
* @description:finish Method to Update the Status of records.
* @param  Database.BatchableContext: Batch Interface
* @return void
*/   

global void finish(Database.BatchableContext bc){
    
    LibISObjectSelector selector= Application.selector.newInstance(Price_List__c.sObjectType);
    PriceListSelector selectorObj=(PriceListSelector)selector;
    List<Price_List__c> priceList=selectorObj.selectInprogressPriceList();    
    List<Price_List__c> morePriceList=new List<Price_List__c>();
    LibISObjectUnitOfWork uow = new LibSObjectUnitOfWork(
        new List<Schema.SObjectType>{Price_List__c.sObjectType}); 
    
    for(Price_List__c pr:priceList){
        pr.Latest_Update_Status__c='Processed';
        uow.registerDirty(pr);    
    }
    uow.commitWork();
    System.debug('In a finish Method');
}
}