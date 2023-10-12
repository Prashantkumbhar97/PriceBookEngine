/**
 * @description       : This trigger is used to start Scheduler based on specific criteria.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 06-23-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/


trigger MonitorScheduler on Monitor_Log__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
   LibSObjectDomain.triggerHandler(MonitorDomain.class);
}