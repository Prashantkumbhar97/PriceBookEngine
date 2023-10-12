trigger CreatePricebookandEntry on Price_List__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    LibSObjectDomain.triggerHandler(PriceListDomain.class);
}