/**
 * @description       : This class Show all Query from Price Book Object.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public without Sharing class  PriceBookSelector extends LibSObjectSelector{
    public Schema.SObjectType getSObjectType(){
        return Pricebook2.SObjectType;
    }
    
/**
* @description:This method is used to define all the fields of Object.
* @return List<Schema.SObjectField>
*/ 
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Pricebook2.Id,
                Pricebook2.Name,
                Pricebook2.Customer__c,
                Pricebook2.Customer_Group__c,
                Pricebook2.Customer_Group__r.Name,
                Pricebook2.Type__c,    
                Pricebook2.IsActive,
                Pricebook2.IsDiscount__c
                };
                    }
        
/**
* @description:This method is used to get All Pricebook.
* @return List<Pricebook2>
*/
    public List<Pricebook2> selectByActivePriceBook(){
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true AND IsDiscount__c=false');          
        System.debug('PriceBook Query in Application'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get All Pricebook data by active checkbox and Discount.
* @return List<Pricebook2>
*/    
    public List<Pricebook2> selectByActivePriceBookwithDiscount(){
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true AND IsDiscount__c=true');          
        System.debug('PriceBook Query in Application'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get All Pricebook data by active checkbox and based on Customer
* @return List<Pricebook2>
*/    
    public List<Pricebook2> priceBookbyCustomer(){
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true and Customer__c !=null');          
        System.debug('PriceBook Query in Application Customer'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get All Pricebook data by active checkbox and based on Customer Group
* @return List<Pricebook2>
*/    

    public List<Pricebook2> priceBookbyCustomerGroup(){
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true and Customer_Group__c !=null');          
        System.debug('PriceBook Query in Application Group'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get All Pricebook data by active checkbox and based on Comman Customer
* @return List<Pricebook2>
*/    
     
    public List<Pricebook2> priceBookbyCustomerComman(){
        String type='Common';
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true and Customer_Group__c =null and Customer__c =null'+ ' And' +' '+ 'Type__c=\''+type+'\'');          
        System.debug('PriceBook Query in Application Group Comman'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get Standard Price Book.
* @return Pricebook2
*/    

    public Pricebook2 getStandardPriceBook(){
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('isStandard=true');          
        System.debug('Query is'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
       
/**
* @description:This method is used to get ALl active and Common type Price Book.
* @return List<Pricebook2>
*/    
    public List<Pricebook2> selectByActivePriceBook1(){
        String type='Common';
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true AND IsDiscount__c=false'+ ' And' +' '+ 'Type__c=\''+type+'\'');          
        System.debug('PriceBook Query in Application'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }
    
/**
* @description:This method is used to get ALl active and Common type Price Book with Discount.
* @return List<Pricebook2>
*/    
    public List<Pricebook2> selectByActivePriceBookwithDiscount1(){
        String type='Common';
        LibQueryFactory aQF = newQueryFactory()
            .setCondition('IsActive =true AND IsDiscount__c=true'+ ' And' +' '+ 'Type__c=\''+type+'\'');          
        System.debug('PriceBook Query in Application'+aQF.toSOQL());    
        return Database.query( aQF.toSOQL());
    }

    
}