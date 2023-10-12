/**
 * @description       : This Class is used to create Price book for Customer Group.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class CreatePriceBookByCustomerGroup implements IPriceBookCreator {
    
/**
* @description:This method is Used Create Price Book For Customer group.
* @param  mapOfCustomerGrp: get the Customer Group Map of Price List Object.
* @param  priceBookbyCustomerGrp: get the value of Customer Group records from Price Book Object.
* @param  priceList: Valueof Price List Object.
* @param  ontrigger: to Check wheather called from trigger or Not.
* @param  jsPriceBook: Field mapping of Price Book from Custom Meta Data.
* @param  jsPriceBookEntry: Field mapping of Price Book Entry from Custom Meta Data
* @param  discount: to Check either discount or not.
* @return void
*/   

public static void createPricebook(Map<String,Price_List__c> mapOfCustomerGrp, Map<String,Pricebook2> priceBookbyCustomerGrp,List<Price_List__c> priceList,String ontrigger,String jsPriceBook,String jsPriceBookEntry,boolean discount)
    {
        Pricebook2 pricebook=new Pricebook2();
        MonitorService x=new  MonitorService();
        String  userId=userInfo.getUserId(); 
         
        try{
            System.debug('In Customer Group Class');            
            LibISObjectUnitOfWork uow=Application.unitOfWork.newInstance();
            for(Price_List__c priceListObj: mapOfCustomerGrp.values()){
                System.debug('Calling Price Book for Customer Group');
                System.debug('Price List Obj'+priceListObj);
                if(priceListObj.Customer_Group__c !=null){ 
                    if(priceBookbyCustomerGrp.get(priceListObj.Customer_Group__c) ==null){             
                        System.debug('Calling Price Book customer group');     
                        Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsPriceBook);
                        JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();
                        for(String key:jsonObj.keySet()){
                            String key1=String.valueof(jsonObj.get(key));
                            
                            System.debug('Key 1 is'+key1);
                            if(key=='Name' && priceListObj.Discount_Price__c==null){
                            gen.writeObjectField(key,'PriceBook-'+priceListObj.Customer_Group__r.Name);
                                
                            }
                            else if(key=='Name' && priceListObj.Price__c==null){
                            gen.writeObjectField(key,'PriceBookDiscount-'+priceListObj.Customer_Group__r.Name);       
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
            x.log('CreatePriceBookByCustomerGroup',pricebook.id, 'CustomerGroup', userId, 'createPricebook','None');
            CreatePriceBookByCustomerGroup.priceBookEntryByCustomerGroup(priceList,ontrigger,jsPriceBookEntry);              
        }
        Catch(Exception e)
        {
            System.debug('Message'+E.getMessage());
            System.debug('Line Cause is'+E.getCause());
            System.debug('Line Number'+e.getLineNumber());  
            x.exceptionHandler(e,null, null, null, 'CreatePriceBookByCustomerGroup','CustomerGroup Error');
        }
    }
 
  /**
* @description:This method is Used Create Price Book Entry For Customer Group.
* @param  priceList: List of Price List.
* @param  ontrigger: to Check for Updating the status
* @param  jsPriceBookEntry: Mapping of Price Book Entry from Custom Meta data.
* @return void.
*/           
   
    public static void priceBookEntryByCustomerGroup(List<Price_List__c> priceList,String ontrigger,String jsPriceBookEntry){
        
        System.debug('PriceList Size is'+priceList);
        String   userId=userInfo.getUserId();
        MonitorService x=new  MonitorService();
        PricebookEntry priceEntry=new PricebookEntry();  
       
        try{
            LibISObjectUnitOfWork uow1=Application.unitOfWork.newInstance();        
            LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
            PriceBookSelector selectorObj=(PriceBookSelector)selector;
            List<Pricebook2> queryPriceBook=selectorObj.priceBookbyCustomerGroup();
            
            Map<String,Pricebook2> priceBookForEntries=new Map<String,Pricebook2>();
            for(Pricebook2 price:queryPriceBook){
                priceBookForEntries.put(price.Customer_Group__c,price);
            }
            for(Price_List__c priceListObj1: priceList){
                Pricebook2 matchingPricebook =new  Pricebook2();
                if(priceListObj1.Customer_Group__c !=null){       
                    if(priceBookForEntries.containsKey(priceListObj1.Customer_Group__c)){          
                        matchingPricebook = priceBookForEntries.get(priceListObj1.Customer_Group__c);
                        System.debug('Matching price book in Customer'+matchingPricebook);            
                        if(ontrigger =='ontrigger'){
                            PriceBookService.createStatusProcess(priceListObj1.id);  
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
            x.log('CreatePriceBookByCustomerGroup',priceEntry.id,'CustomerGroup',userId,'No Error','None');
        }
        catch(Exception e)
        {
            System.debug('Error Message'+e.getMessage());
            x.exceptionHandler(e, priceEntry.id, null, null,'CreatePriceBookByCustomerGroup','CustomerGroup');
        }       
    }
}