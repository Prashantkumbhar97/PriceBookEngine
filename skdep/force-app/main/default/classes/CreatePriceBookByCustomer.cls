/**
 * @description       : This Class is used to create Price book for Customer.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class CreatePriceBookByCustomer implements IPriceBookCreator {

/**
* @description:This method is Used Create Price Book For Customer.
* @param  mapOfCustomer: get the Customer Map of Price List Object.
* @param  priceBookbyCustomer: get the value of Customer from Price Book Object.
* @param  priceList: Valueof Price List Object.
* @param  ontrigger: to Check wheather called from trigger or Not.
* @param  jsPriceBook: Field mapping of Price Book from Custom Meta Data.
* @param  jsPriceBookEntry: Field mapping of Price Book Entry from Custom Meta Data
* @param  discount: to Check either discount or not.
* @return void
*/   

public static void createPricebook(Map<String,Price_List__c> mapOfCustomer, Map<String,Pricebook2> priceBookbyCustomer,List<Price_List__c> priceList,String ontrigger,String jsPriceBook,String jsPriceBookEntry,boolean discount)       
{    
    Pricebook2 pricebook=new Pricebook2();
    MonitorService x=new  MonitorService();
    String  userId=userInfo.getUserId();    
    try{
        System.debug('In Customer Class');
        
        LibISObjectUnitOfWork uow=Application.unitOfWork.newInstance();         
        for(Price_List__c priceListObj: mapOfCustomer.values()){
            System.debug('Price List Obj Customer'+priceListObj.Customer__c);
            if(priceListObj.Customer__c!=null){
                if(!priceBookbyCustomer.containskey(priceListObj.Customer__c)){           
                    System.debug('Calling Price Book Customer'); 
                    
                    Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsPriceBook);
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    for(String key:jsonObj.keySet()){
                        System.debug('Key is'+key);
                        System.debug('key Value is1'+jsonObj.get(key));
                        String key1=String.valueof(jsonObj.get(key));
                        
                        if(key=='Name' && priceListObj.Discount_Price__c==null){
                            System.debug('Name is'+priceListObj.Customer__r.Name);    
                            gen.writeObjectField(key,'PriceBook-'+priceListObj.Customer__r.Name);
                            
                        }
                        else if(key=='Name' && priceListObj.Price__c==null){
                            gen.writeObjectField(key,'PriceBookDiscount-'+priceListObj.Customer__r.Name);
                            
                        }
                        else if(key=='Type__c'){
                            gen.writeObjectField(key,key1);
                            
                        }
                        else{
                            gen.writeObjectField(key,priceListObj.get(key1));    
                        }
                    }
                    gen.writeEndObject();
                    
                    String jsonS = gen.getAsString(); 
                    Map<String, Object> jsonObj1 = (Map<String, Object>) JSON.deserializeUntyped(jsonS);
                    jsonObj1.put('IsActive','true');
                    if(discount==true){
                        jsonObj1.put('IsDiscount__c','true');    
                    }
                    String jsonStri = JSON.serialize(jsonObj1);
                    System.debug('Final String is'+jsonStri);
                    
                    //Today 07/10/2023
                    
                    LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
                    PriceBookSelector selectorObj=(PriceBookSelector)selector;
                    Pricebook2 standardPB=selectorObj.getStandardPriceBook(); 
                        
                    LibISObjectSelector selector1= Application.selector.newInstance(PricebookEntry.sObjectType);
                    PriceBookEntrySelector selectorObj1=(PriceBookEntrySelector)selector1;
                    List<PricebookEntry> standardPBE=selectorObj1.getStandardPriceBookEntry(standardPB.Id,priceListObj.Product__c); 
                    
                    if(standardPBE.Size() ==0){
                        PricebookEntry stand=new PricebookEntry();
                        stand.Pricebook2Id=standardPB.id;
                        stand.Product2Id=priceListObj.Product__c;
                        
                        if(priceListObj.Price__c !=null){
                            stand.UnitPrice=priceListObj.Price__c;    
                        }
                        else if(priceListObj.Discount_Price__c !=null){
                            stand.UnitPrice=priceListObj.Discount_Price__c;       
                        }
                        stand.IsActive=true;
                        
                        uow.registerNew(stand);
                    }
                    
                    pricebook=(Pricebook2)JSON.deserialize(jsonStri, Pricebook2.class);
                    uow.registerNew(pricebook);   
                    
                }        
            }
        }
        uow.commitWork();
        
        x.log('CreatePriceBookByCustomer',pricebook.id, 'Customer', userId,null,null); 
        CreatePriceBookByCustomer.createPricebookEntryByCustomer(priceList,ontrigger,jsPriceBookEntry);        
    }
    Catch(Exception e)
    {
        System.debug('Message'+E.getMessage());
        System.debug('Line Cause is'+E.getCause());
        System.debug('Line Number'+e.getLineNumber()); 
        x.exceptionHandler(e,null, null, null, 'CreatePriceBookByCustomer','Customer Error');
        
    } 
}

/**
* @description:This method is Used Create Price Book Entry For Customer.
* @param  priceList: List of Price List.
* @param  ontrigger: to Check for Updating the status
* @param  jsPriceBookEntry: Mapping of Price Book Entry from Custom Meta data.
* @return void.
*/   
public static void createPricebookEntryByCustomer(List<Price_List__c> priceList,String ontrigger,String jsPriceBookEntry){
    
    System.debug('JSonPriceBook EWntry is'+jsPriceBookEntry);
    String   userId=userInfo.getUserId();
    MonitorService x=new  MonitorService();
    PricebookEntry priceEntry=new PricebookEntry();
    System.debug('PriceListSize Is'+priceList.size());
    
    try{
        
        LibISObjectUnitOfWork uow=Application.unitOfWork.newInstance();
        LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
        PriceBookSelector selectorObj=(PriceBookSelector)selector;
        List<Pricebook2> queryPriceBook=selectorObj.priceBookbyCustomer();
        
        Map<String,Pricebook2> priceBookForEntries=new Map<String,Pricebook2>();
        
        for(Pricebook2 price:queryPriceBook){
            priceBookForEntries.put(price.Customer__c,price);
        }
        
        for(Price_List__c priceListObj1: priceList){ 
            system.debug('inside priceBookForEntries>'+priceBookForEntries);
            Pricebook2 matchingPricebook =new  Pricebook2();
            
            if(priceListObj1.Customer__c !=null){   
                system.debug('priceListObj1.Customer__c>>>>'+priceListObj1.Customer__c);
                
                if(priceBookForEntries.containsKey(priceListObj1.Customer__c)){   
                    system.debug('inside if');
                    matchingPricebook = priceBookForEntries.get(priceListObj1.Customer__c);
                    
                    if(ontrigger =='ontrigger'){
                        PriceBookService.createStatusProcess(priceListObj1.id) ;        
                    }
                    else{
                        priceListObj1.Latest_Update_Status__c='In progress'; 
                        uow.registerUpsert(priceListObj1);   
                    }            
                    system.debug('matchingPricebook>>'+matchingPricebook);
                    
                    Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsPriceBookEntry);
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    for(String key:jsonObj.keySet()){
                        
                        String key1=String.valueof(jsonObj.get(key));
                        System.debug('key1 is One By one'+key1);
                        gen.writeObjectField(key,priceListObj1.get(key1));
                        
                    }
                    gen.writeEndObject();
                    
                    String jsonS = gen.getAsString(); 
                    System.debug('MAp String is11'+jsonS);
                    Map<String, Object> jsonObj1 = (Map<String, Object>) JSON.deserializeUntyped(jsonS);
                    jsonObj1.put('Pricebook2Id',matchingPricebook.Id);
                    jsonObj1.put('UseStandardPrice','false');
                    
                    String jsonStri = JSON.serialize(jsonObj1);
                    System.debug('Final String is11'+jsonStri);
                    
                    priceEntry=(PricebookEntry)JSON.deserialize(jsonStri, PricebookEntry.class);  
                    uow.registerNew(priceEntry);
                }   
            }
        }
        
        uow.commitWork();
        x.log('CreatePriceBookByCustomer',priceEntry.id,'Customer',userId,'No Error','None');
        
    }
    Catch(Exception e)
    {
        System.debug('Message'+E.getMessage());
        System.debug('Line Cause is'+E.getCause());
        System.debug('Line Number'+e.getLineNumber());  
        x.exceptionHandler(e, priceEntry.id, null, null,'CreatePriceBookByCustomer','Customer');
    }
}     
}