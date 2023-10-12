/**
 * @description       : This class show all Query of PriceBookEngine  Custom meta data.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public without sharing class PriceBookEngineSelector extends LibSObjectSelector{
public Schema.SObjectType getSObjectType(){
return PriceBookEntry__mdt.SObjectType;
} 

/**
* @description:This method is used Define All fields of Meta data object.
* @return List<Schema.SObjectField>
*/
public List<Schema.SObjectField> getSObjectFieldList(){
return new List<Schema.SObjectField> {
    PriceBookEntry__mdt.Id,
        PriceBookEntry__mdt.Label,
        PriceBookEntry__mdt.Class_Name__c,
        PriceBookEntry__mdt.Price_Book_JSON__c,
        PriceBookEntry__mdt.Price_Entry_JSON__c
            
        };
            
            }         


/**
* @description:This method is used to retrive Customer data.
* @return PriceBookEntry__mdt
*/
public PriceBookEntry__mdt selectMetaDatabyCustomer(){
String type='Customer';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Customer is'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}

/**
* @description:This method is used to retrive Customer data Discount.
* @return PriceBookEntry__mdt
*/    
public PriceBookEntry__mdt selectMetaDatabyCustomerDiscount(){
String type='CustomerDiscount';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Customer Discount is'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}


/**
* @description:This method is used to retrive Customer Group data.
* @return PriceBookEntry__mdt
*/    
public PriceBookEntry__mdt selectMetaDatabyCustomerGroup(){
String type='CustomerGroup';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Customer Group is'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}

/**
* @description:This method is used to retrive Customer Group Discount data.
* @return PriceBookEntry__mdt
*/    
public PriceBookEntry__mdt selectMetaDatabyCustomerGroupDiscount(){
String type='CustomerGroupDiscount';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Customer Group Discount is'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}

/**
* @description:This method is used to retrive Common data.
* @return PriceBookEntry__mdt
*/    
public PriceBookEntry__mdt selectMetaDatabyComman(){
String type='Common';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Comman Query'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}

/**
* @description:This method is used to retrive Common Discount data.
* @return PriceBookEntry__mdt
*/    
public PriceBookEntry__mdt selectMetaDatabyCommanDiscount(){
String type='CommonDiscount';    
LibQueryFactory aQF = newQueryFactory()
    .setCondition('label=\''+type+'\'');          
System.debug('Comman Discount Query'+aQF.toSOQL());    
return Database.query( aQF.toSOQL());
}


}