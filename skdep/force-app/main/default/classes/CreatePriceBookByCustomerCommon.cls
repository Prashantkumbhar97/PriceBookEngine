/**
 * @description       : This Class is used to create Price book for Common.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class CreatePriceBookByCustomerCommon implements IPriceBookCreator {
    
/**
* @description:This method is Used Create Price Book For Common..
* @param  mapOfCustomerCommon: get the Comman Map of Price List Object.
* @param  priceBookbyCommon: get the value of Comman records from Price Book Object.
* @param  priceList: Valueof Price List Object.
* @param  ontrigger: to Check wheather called from trigger or Not.
* @param  jsPriceBook: Field mapping of Price Book from Custom Meta Data.
* @param  jsPriceBookEntry: Field mapping of Price Book Entry from Custom Meta Data
* @param  discount: to Check either discount or not.
* @return void
*/   
    
    public static void createPricebook(Map<String,Price_List__c> mapOfCustomerCommon, Map<String,Pricebook2> priceBookbyCommon,List<Price_List__c> priceList,String ontrigger,String jsPriceBook,String jsPriceBookEntry,boolean discount){
        Pricebook2 pricebook=new Pricebook2();
        MonitorService x=new  MonitorService();
        String  userId=userInfo.getUserId();     
       
        try{  
            LibISObjectUnitOfWork uow=Application.unitOfWork.newInstance();
            for(Price_List__c priceListObj: mapOfCustomerCommon.values()){
                
                System.debug('Calling Price Book for Comman Customer');
                System.debug('Discount is'+priceListObj.Discount_Price__c);
                System.debug('Price is'+priceListObj.Price__c);
                            
                if(priceListObj.Customer__c==null && priceListObj.Customer_Group__c==null){ 
                    
                    System.debug('Common Map is'+priceBookbyCommon.get('Common'));
                    if(priceBookbyCommon.get('Common') ==null){  
                        
                        Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsPriceBook);
                        JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();
                        for(String key:jsonObj.keySet()){
                         String key1=String.valueof(jsonObj.get(key));
                            
                            
                            if(key=='Name' && priceListObj.Discount_Price__c==null){
                            gen.writeObjectField(key,'PriceBook-Common');
                                
                            }
                            
                            else if(key=='Name' && priceListObj.Price__c==null){
                            gen.writeObjectField(key,'PriceBookDiscount-Common');
                                   
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
                        System.debug('MAp String is'+jsonS);
                        Map<String, Object> jsonObj1 = (Map<String, Object>) JSON.deserializeUntyped(jsonS);
                        jsonObj1.put('IsActive','true'); 
                        if(discount==true){
                        jsonObj1.put('IsDiscount__c','true');    
                        }
                        String jsonStri = JSON.serialize(jsonObj1);
                        System.debug('Final String is'+jsonStri);
                        
                        LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
                        PriceBookSelector selectorObj=(PriceBookSelector)selector;
                        Pricebook2 standardPB=selectorObj.getStandardPriceBook(); 
                        
                        
                        LibISObjectSelector selector1= Application.selector.newInstance(PricebookEntry.sObjectType);
                        PriceBookEntrySelector selectorObj1=(PriceBookEntrySelector)selector1;
                        
                        List<PricebookEntry> standardPBE=selectorObj1.getStandardPriceBookEntry(standardPB.Id,priceListObj.Product__c); 
                        
                        
                        System.debug('Standard Price Book Present or not'+standardPBE);
                        System.debug('Standard Price Book Size'+standardPBE.size());
                        
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
                        System.debug('Insert Object is'+pricebook);
                    }
                }
            }
            uow.commitWork();
            x.log('CreatePriceBookByCustomerCommon',pricebook.id, 'CommanCustomer', userId, 'Comman Customer','None');
            CreatePriceBookByCustomerCommon.createPbEntryByCommon(priceList,ontrigger,jsPriceBookEntry);
        }
        Catch(Exception e)
        {
            System.debug('Message'+E.getMessage());
            System.debug('Line Cause is'+E.getCause());
            System.debug('Line Number'+e.getLineNumber());  
            x.exceptionHandler(e,null, null, null, 'CreatePriceBookByCustomerCommon','CustomerComman Error');
        }
    }
    
 /**
* @description:This method is Used Create Price Book Entry For Common.
* @param  priceList: List of Price List.
* @param  ontrigger: to Check for Updating the status
* @param  jsPriceBookEntry: Mapping of Price Book Entry from Custom Meta data.
* @return void.
*/   
public static void createPbEntryByCommon(List<Price_List__c> priceList,String ontrigger,String jsPriceBookEntry){
        
        System.debug('priceList size is'+priceList.size());
        String   userId=userInfo.getUserId();
        MonitorService x=new  MonitorService();
        PricebookEntry priceEntry=new PricebookEntry();  
        try{
            LibISObjectUnitOfWork uow1 =Application.unitOfWork.newInstance();
            
            LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
            PriceBookSelector selectorObj=(PriceBookSelector)selector;
            List<Pricebook2> queryPriceBook=selectorObj.priceBookbyCustomerComman();
            
            Map<String,Pricebook2> priceBookForEntries=new Map<String,Pricebook2>();
            for(Pricebook2 price:queryPriceBook){
                priceBookForEntries.put('Common',price);
            }
            
            for(Price_List__c priceListObj1: priceList){     
                Pricebook2 matchingPricebook =new  Pricebook2();
                
                if(priceListObj1.Customer__c ==null && priceListObj1.Customer_Group__c==null){
                    System.debug('lll---'+priceBookForEntries.containsKey('Common'));
                    if(priceBookForEntries.containsKey('Common')){   
                        matchingPricebook = priceBookForEntries.get('Common');
                        System.debug('Matching price book in Customer Comman'+matchingPricebook);
                        if(ontrigger =='ontrigger'){
                            PriceBookService.createStatusProcess(priceListObj1.id) ;  
                        }
                        else{
                            priceListObj1.Latest_Update_Status__c='In progress'; 
                            uow1.registerUpsert(priceListObj1);   
                        }
                        system.debug('matchingPricebook>>'+matchingPricebook);
                           
                        Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsPriceBookEntry);
                        JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();
                        for(String key:jsonObj.keySet()){
                            String key1=String.valueof(jsonObj.get(key));
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
                        uow1.registerNew(priceEntry);
                    }   
                }    
            }
            uow1.commitWork();
            x.log('CreatePriceBookByCustomerCommon',priceEntry.id,'CommanCustomer',userId,'CommanCustomer','None');
        }
        Catch(Exception e) {
            System.debug('In common'+e.getMessage());
            System.debug('Line Number is'+e.getLineNumber());
            System.debug('Cause is'+e.getCause());
            x.exceptionHandler(e, priceEntry.id, null, null,'CreatePriceBookByCustomerCommon','CommanCustomer');
        }
    }
}