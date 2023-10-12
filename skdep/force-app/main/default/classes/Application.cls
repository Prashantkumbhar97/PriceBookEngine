/**
 * @description       : This Class is used to create All layer like service,selector,domain and unit of work.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class Application {

/**
* @description:This method Objects which will used in DML Operations.
*/   
public static final LibApplication.UnitOfWorkFactory unitOfWork =
   new LibApplication.UnitOfWorkFactory(
      new List<SObjectType> {
            Account.sObjectType,
            Price_List__c.sObjectType,
            Pricebook2.sObjectType,
            PricebookEntry.sObjectType,   
            Monitor_Log__c.sObjectType,
            Attachment.sObjectType,
            ContentDocumentLink.sObjectType,    
            ContentVersion.sObjectType,
            PriceBookEntry__mdt.sObjectType
                           
      }
   ); 

/**
* @description:Service Layer is Used to perform Actual Logic.
*/
public static final LibApplication.ServiceFactory service =
   new LibApplication.ServiceFactory(
      new Map<Type, Type> {
      IPriceBookService.class =>IPriceBookServiceImp.class, 
      IPriceBookCreator.class =>CreatePriceBookByCustomerCommon.class,
      IPriceBookCreator.class =>CreatePriceBookByCustomer.class,
      IPriceBookCreator.class =>CreatePriceBookByCustomerGroup.class,         
      IMonitor.class => MonitorImp.class    
      }
   );

/**
* @description:Selector Layer is Used to perform SOQL Query.
*/   
public static final LibApplication.SelectorFactory selector =
   new LibApplication.SelectorFactory(
      new Map<SObjectType, Type> {
            Pricebook2.sObjectType => PriceBookSelector.class,
            Price_List__c.sObjectType  =>PriceListSelector.class,
            ContentDocumentLink.sObjectType=>ContentDocumentLinkSelector.class,
            ContentVersion.sObjectType =>ContentVersionSelector.class,
            User.sObjectType =>UserSelector.class,
            PriceBookEntry__mdt.sObjectType =>PriceBookEngineSelector.class,
            PricebookEntry.sObjectType =>PriceBookEntrySelector.class     
      }
   );

/**
* @description:Domain Layer is Used to perform Trigger Operation.
*/   
public static final LibApplication.DomainFactory domain =
   new LibApplication.DomainFactory(
      Application.Selector,
      new Map<SObjectType, Type> {
         Price_List__c.sObjectType => PriceListDomain.class,
         Monitor_Log__c.sObjectType=>MonitorDomain.class    
      }
   );
}