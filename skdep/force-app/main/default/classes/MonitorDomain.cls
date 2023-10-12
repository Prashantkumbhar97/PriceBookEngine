/**
 * @description       : This class help the Monitor Trigger to perform various actions.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class MonitorDomain extends LibSObjectDomain {
    
    public MonitorDomain(List<Monitor_Log__c> records){
        super(records);
    }
    
    public class Constructor implements LibSObjectDomain.IConstructable {  
        public LibSObjectDomain construct(List<sObject> sObjectList) {
            System.debug('sObjectList List'+sObjectList);
            return new MonitorDomain(sObjectList);    }
    }
    
    MonitorLogGenerateFile scheduledJob = new MonitorLogGenerateFile();
    String jobId='';
    String recordtypeId= Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Scheduler').getRecordTypeId();
    String userId=userInfo.getUserId();
    String monitorId='';
    
/**
* @description:This method is Called after insert of Monitor Data.
* @return void.
*/

    public Override void onBeforeInsert(){
        System.debug('After Insert Send Email');
        String onTrigger='ontrigger';
        for(sObject logObj:(List<Monitor_Log__c>)records)
        {
            Monitor_Log__c monitor=(Monitor_Log__c)logObj;
            if (monitor.Status__c == true && monitor.Purging_Schedule__c != null && monitor.RecordTypeId == recordtypeId) {
                jobId = System.schedule(monitor.Name, monitor.Purging_Schedule__c, scheduledJob);
                monitor.Schedule_Job_Id__c = jobId;
                monitor.Purged_Status__c = 'In Progress';
                monitor.Concern_Person__c = userId;
                
            }
        }   
    }
     
/**
* @description:This method is Called after update of Monitor Records.
* @return void.
*/
    public Override void onAfterUpdate(map<id, SObject> existing){
        for(sObject logObj:(List<Monitor_Log__c>)records)
        {
            Monitor_Log__c monitorObj=(Monitor_Log__c)logObj;
            if (monitorObj.Status__c == false && monitorObj.Schedule_Job_Id__c != null) {
                monitorObj.Schedule_Job_Id__c = '';
            }
            if (monitorObj.ReloadStatus__c == 'Start' && monitorObj.Schedule_Job_Id__c != null) {
                monitorId = monitorObj.Id;
                MonitorService.reloadRecords(monitorId);
            } else if (monitorObj.ReloadStatus__c == 'Start' && monitorObj.Schedule_Job_Id__c == null) {
                monitorObj.addError('Scheduled Job is Blank');
            }
        }
    }
}