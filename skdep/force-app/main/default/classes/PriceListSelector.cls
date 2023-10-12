/**
 * @description       : This class Show all Query from Price List Object.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public without Sharing class PriceListSelector extends LibSObjectSelector{
public Schema.SObjectType getSObjectType(){
    return Price_List__c.SObjectType;
}

/**
* @description:This method is used to define all the fields of Object
* @return List<Schema.SObjectField>
*/
public List<Schema.SObjectField> getSObjectFieldList(){
    return new List<Schema.SObjectField> {
        Price_List__c.Id,
            Price_List__c.Name,
            Price_List__c.Customer__c,
            Price_List__c.Customer_Group__c,
            Price_List__c.Customer_Group__r.Name,
            Price_List__c.Product__c,    
            Price_List__c.Price__c,
            Price_List__c.Start_Date__c,
            Price_List__c.End_Date__c,
            Price_List__c.Combination_Key__c,
            Price_List__c.Latest_Update_Status__c,
            Price_List__c.Customer__r.Name,
            Price_List__c.Discount_Price__c,
            Price_List__c.OnDemand__c
            };
        }

/**
* @description:This method is used to get Price List whose Status is Open
* @return Database.QueryLocator
*/
    
public Database.QueryLocator allPriceList(){
    String status='Open';
    string query;
    query = 'SELECT Id, Name, Customer__c,Customer__r.Name, Customer_Group__c,Customer_Group__r.Name, Product__c, Price__c, Start_Date__c, End_Date__c, Combination_Key__c, Latest_Update_Status__c,Discount_Price__c FROM Price_List__c Where Latest_Update_Status__c=';
    query=query+ '\''+status+'\'';
    System.debug('Query is'+query);       
    return Database.getQueryLocator(query);
}

/**
* @description:This method is used to get Price List whose Status is Open and On demand checkbox is true
* @return Database.QueryLocator
*/    
public Database.QueryLocator allPriceListonDemand(){
    boolean strParameter=true;
    String status='Open';
    string query;
    query = 'SELECT Id, Name, Customer__c,Customer__r.Name, Customer_Group__c,Customer_Group__r.Name, Product__c, Price__c, Start_Date__c, End_Date__c, Combination_Key__c, Latest_Update_Status__c,Discount_Price__c FROM Price_List__c Where Latest_Update_Status__c=';
    query=query+ '\''+status+'\''+' AND OnDemand__c='+strParameter;
    System.debug('Query Seond is'+query);       
    return Database.getQueryLocator(query);
}
    
/**
* @description:This method is used to get Price List whose Status is in progress.
* @return List<Price_List__c>
*/    
    
public List<Price_List__c> selectInprogressPriceList(){
    String status='In progress';    
    LibQueryFactory aQF = newQueryFactory()
        .setCondition('Latest_Update_Status__c=\''+status+'\'');          
    System.debug('PriceList Query in Application'+aQF.toSOQL());    
    return Database.query( aQF.toSOQL());
}

/**
* @description:This method is used to get Price List based on RecordId.
* @return Price_List__c
*/    
public Price_List__c selectById(Id recordIds){
    LibQueryFactory query = newQueryFactory();
    query.setCondition('Id =:recordIds');
    System.debug('Query is'+query.toSOQL());
    return Database.query( query.toSOQL());    
}

/**
* @description:This method is used to get Price List Based on Trigger.
* @return List<Price_List__c>
*/   
    public List<Price_List__c> selectByTriggerAll1(){
    boolean strParameter=false;
    String status='Open';
    string query;
    query = 'SELECT Id, Name, Customer__c,Customer__r.Name, Customer_Group__c,Customer_Group__r.Name, Product__c, Price__c, Start_Date__c, End_Date__c, Combination_Key__c, Latest_Update_Status__c,Discount_Price__c FROM Price_List__c Where Latest_Update_Status__c=';
    query=query+ '\''+status+'\''+' AND OnDemand__c='+strParameter;
    System.debug('Query Seond is'+query);       
    return Database.query(query);
}

}