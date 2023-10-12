/**
 * @description       : This class get all the data from Price list and based on data call diff-diff classes.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

global without Sharing class PriceBookService extends IPriceBookServiceImp {
    
/** 
* @Description - This method is Used Call Different Classes based on PriceList Data. 
* @param List :priceList,String-Ontrigger.
* @return  -    void
*/           
    public override void createPriceBookAndEntries(List<Price_List__c> priceList,String ontrigger)
    {
        try{  
            
            LibISObjectSelector selector20= Application.selector.newInstance(Price_List__c.sObjectType);
             PriceListSelector selectorObj20=(PriceListSelector)selector20;
             List<Price_List__c> priceListTri=selectorObj20.selectByTriggerAll1(); 
                 
            List<Price_List__c> priceListDiscount=new List<Price_List__c>();
            List<Price_List__c> priceListPrice=new List<Price_List__c>();
            
            if(ontrigger =='ontrigger'){
             for(Price_List__c pr:priceListTri){
                if(pr.Price__c==null){
                   priceListDiscount.add(pr); 
                }
                else if(pr.Discount_Price__c==null){       
                    priceListPrice.add(pr);
                } 
            }
                
            }
            else{
            
           for(Price_List__c pr:priceList){
                if(pr.Price__c==null){
                   priceListDiscount.add(pr); 
                }
                else if(pr.Discount_Price__c==null){       
                    priceListPrice.add(pr);
                } 
            }
            }
             
            LibISObjectSelector selector= Application.selector.newInstance(Pricebook2.sObjectType);
            PriceBookSelector selectorObj=(PriceBookSelector)selector;
            List<Pricebook2> queryPriceBook=selectorObj.selectByActivePriceBook();
            
            List<Pricebook2> queryPriceBook1=selectorObj.selectByActivePriceBookwithDiscount();
               
            List<Pricebook2> queryPriceBook2=selectorObj.selectByActivePriceBook1();
            
            List<Pricebook2> queryPriceBook3=selectorObj.selectByActivePriceBookwithDiscount1();
            
            LibISObjectSelector selector1= Application.selector.newInstance(PriceBookEntry__mdt.sObjectType);
            PriceBookEngineSelector selectorObj1=(PriceBookEngineSelector)selector1;
            
            //*************************************Customer Part Start ***********************************************************//
            
                  //***************For Customer Price********************************//
            Map<String,Pricebook2> priceBookbyCustomer=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomer=new Map<String,Price_List__c>();
            
            for(Price_List__c priceListObj2: priceListPrice){
                priceListByCustomer.put(priceListObj2.Customer__c,priceListObj2);
            }
            for(Pricebook2 prc:queryPriceBook){
                priceBookbyCustomer.put(prc.Customer__c,prc);
            }
            
            PriceBookEntry__mdt msd=selectorObj1.selectMetaDatabyCustomer(); 
            String jsPriceBook1=msd.Price_Book_JSON__c;
            String jsPriceBookEntry1=msd.Price_Entry_JSON__c;
            IPriceBookCreator newCustomer= PriceBookObjectCreator.className('Customer');  
                   
            for(Price_List__c priceList1:priceListByCustomer.values()){  
                if(priceList1.Customer__c !=null && priceList1.Price__c !=null && priceList1.Discount_Price__c ==null)
                {
                    newCustomer.createPricebook(priceListByCustomer, priceBookbyCustomer, priceListPrice, ontrigger,jsPriceBook1,jsPriceBookEntry1,false);
                }
            }
            
            
                  //***************For Customer Discount********************************//
            Map<String,Pricebook2> priceBookbyCustomer1=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomer1=new Map<String,Price_List__c>();
            
            for(Price_List__c priceListObj2: priceListDiscount){
                priceListByCustomer1.put(priceListObj2.Customer__c,priceListObj2);
            }
            for(Pricebook2 prc:queryPriceBook1){
                priceBookbyCustomer1.put(prc.Customer__c,prc);
            }
            
            PriceBookEntry__mdt msd1=selectorObj1.selectMetaDatabyCustomerDiscount(); 
            String jsPriceBook2=msd1.Price_Book_JSON__c;
            String jsPriceBookEntry2=msd1.Price_Entry_JSON__c;
            for(Price_List__c priceList1:priceListByCustomer1.values()){        
                 if(priceList1.Customer__c != null && priceList1.Discount_Price__c != null && priceList1.Price__c ==null){
                    newCustomer.createPricebook(priceListByCustomer1, priceBookbyCustomer1, priceListDiscount, ontrigger,jsPriceBook2,jsPriceBookEntry2,true);    
                }
            } 
            
            //*************************************Customer Part End *******************************************************************//
            
            
            //*************************************Customer Group Part Start ***********************************************************//
              
                 //********************For Customer Group Price*********/
            Map<String,Pricebook2> priceBookbyCustomerGroup=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomerGroup=new Map<String,Price_List__c>();
            
            for(Price_List__c priceListObj2: priceListPrice){
                priceListByCustomerGroup.put(priceListObj2.Customer_Group__c,priceListObj2);
            }
            for(Pricebook2 prc:queryPriceBook){
                priceBookbyCustomerGroup.put(prc.Customer_Group__c,prc);
            }
            
            PriceBookEntry__mdt msd2=selectorObj1.selectMetaDatabyCustomerGroup(); 
            String jsPriceBook3=msd2.Price_Book_JSON__c;
            String jsPriceBookEntry3=msd2.Price_Entry_JSON__c;
            
            IPriceBookCreator newCustomerGrp= PriceBookObjectCreator.className('CustomerGroup');
            for(Price_List__c priceList1:priceListByCustomerGroup.values()){    
                if(priceList1.Customer_Group__c !=null &&  priceList1.Price__c !=null && priceList1.Discount_Price__c ==null){    
                    newCustomerGrp.createPricebook(priceListByCustomerGroup, priceBookbyCustomerGroup,priceListPrice,ontrigger,jsPriceBook3,jsPriceBookEntry3,false);
                }
            }
             
                //******************For Customer Group Discount********//
            Map<String,Pricebook2> priceBookbyCustomerGroup1=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomerGroup1=new Map<String,Price_List__c>();
           
            for(Price_List__c priceListObj2: priceListDiscount){
                priceListByCustomerGroup1.put(priceListObj2.Customer_Group__c,priceListObj2);
            }
            for(Pricebook2 prc:queryPriceBook1){
                priceBookbyCustomerGroup1.put(prc.Customer_Group__c,prc);
            }
              
            PriceBookEntry__mdt msd3=selectorObj1.selectMetaDatabyCustomerGroupDiscount(); 
            String jsPriceBook4=msd3.Price_Book_JSON__c;
            String jsPriceBookEntry4=msd3.Price_Entry_JSON__c;
            
            for(Price_List__c priceList1:priceListByCustomerGroup1.values()){     
                 if(priceList1.Customer_Group__c !=null &&  priceList1.Discount_Price__c !=null && priceList1.Price__c ==null){
                    newCustomerGrp.createPricebook(priceListByCustomerGroup1, priceBookbyCustomerGroup1,priceListDiscount,ontrigger,jsPriceBook4,jsPriceBookEntry4,true);
                }
            }
           
            
            //*************************************Customer Group Part End ***********************************************************//
            
            
            //*************************************Comman Part Start *****************************************************************//
            
               // ********************For Common Price********//
            Map<String,Pricebook2> priceBookbyCustomerComman=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomerComman=new Map<String,Price_List__c>();
            
            for(Price_List__c priceListObj2: priceListPrice){
                if(priceListObj2.Customer__c==null && priceListObj2.Customer_Group__c==null && priceListObj2.Price__c !=null && priceListObj2.Discount_Price__c ==null){
                
                    priceListByCustomerComman.put('Common',priceListObj2);
                }
                
            }
            for(Pricebook2 prc:queryPriceBook2){
                if(prc.Customer__c==null && prc.Customer_Group__c==null ){
                priceBookbyCustomerComman.put('Common',prc);    
                }
                
            }
            
            PriceBookEntry__mdt msd4=selectorObj1.selectMetaDatabyComman(); 
            String  jsPriceBook5=msd4.Price_Book_JSON__c;
            String jsPriceBookEntry5=msd4.Price_Entry_JSON__c;
            
            IPriceBookCreator newCommonObj= PriceBookObjectCreator.className('Common');    
            for(Price_List__c priceList1:priceListByCustomerComman.values()){
                if(priceList1.Customer__c==null && priceList1.Customer_Group__c==null  && priceList1.Price__c !=null && priceList1.Discount_Price__c ==null){
                    System.debug('calling Price Class');
                    newCommonObj.createPricebook(priceListByCustomerComman, priceBookbyCustomerComman,priceListPrice,ontrigger,jsPriceBook5,jsPriceBookEntry5,false);   
            }
            }
           
              //****************For Comman Discount**************// 
            Map<String,Pricebook2> priceBookbyCustomerComman1=new Map<String,Pricebook2>();
            Map<String,Price_List__c> priceListByCustomerComman1=new Map<String,Price_List__c>();
            
            for(Price_List__c priceListObj2: priceListDiscount){
                if(priceListObj2.Customer__c==null && priceListObj2.Customer_Group__c==null && priceListObj2.Discount_Price__c !=null && priceListObj2.Price__c ==null){
                 priceListByCustomerComman1.put('Common',priceListObj2);    
                }
            }
            for(Pricebook2 prc:queryPriceBook3){
                if(prc.Customer__c==null && prc.Customer_Group__c==null){
                priceBookbyCustomerComman1.put('Common',prc);
                }
            }
            PriceBookEntry__mdt msd5=selectorObj1.selectMetaDatabyCommanDiscount(); 
            String  jsPriceBook6=msd5.Price_Book_JSON__c;
            String  jsPriceBookEntry6=msd5.Price_Entry_JSON__c;
             
            for(Price_List__c priceList1:priceListByCustomerComman1.values()){
                 if(priceList1.Customer__c==null && priceList1.Customer_Group__c==null  && priceList1.Discount_Price__c !=null && priceList1.Price__c ==null){    
                  System.debug('calling Price Class Discount'); 
                  newCommonObj.createPricebook(priceListByCustomerComman1, priceBookbyCustomerComman1,priceListDiscount,ontrigger,jsPriceBook6,jsPriceBookEntry6,true);         
                }
            }
            //*************************************Comman Part End ***********************************************************//
            
        }
        Catch(Exception e)
        {
            System.debug('Message'+E.getMessage());
            System.debug('Line Cause is'+E.getCause());
            System.debug('Line Number'+e.getLineNumber());             
        }          
    }
    
/** 
* @Description - This method is Used to Call Batch for Bulk Record. 
* @param List -priceList,String-Ontrigger.
* @return  -    void
*/              
    webservice static void onDemandInvoke(){
        CreatePriceBookBatch shn = new CreatePriceBookBatch(True); 
        database.executeBatch(shn);  
    } 
    
/** 
* @Description - This method is Used to Update Status of the Record. 
* @param Id-valueTrigger.
* @return  - void
*/    
    
    @future
    public static void createStatusProcess(Id valueTrigger){
        LibISObjectSelector selector= Application.selector.newInstance(Price_List__c.sObjectType);
        PriceListSelector selectorObj=(PriceListSelector)selector;
        Price_List__c price=selectorObj.selectById(valueTrigger); 
        price.Latest_Update_Status__c='Processed';
        LibISObjectUnitOfWork uow=Application.unitOfWork.newInstance();
        uow.registerDirty(price);
        uow.commitWork();   
    }  
}