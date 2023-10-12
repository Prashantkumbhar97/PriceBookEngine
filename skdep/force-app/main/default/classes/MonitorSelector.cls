/**
 * @description       : This class show all Query of Monitor object.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/


public class MonitorSelector extends LibSObjectSelector {
    
    public Schema.SObjectType getSObjectType(){
        return Monitor_Log__c.SObjectType;
    }
    
/**
* @description:This method is used to define all the fields of Object.
* @return List<Schema.SObjectField>
*/ 
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Monitor_Log__c.Id,
                Monitor_Log__c.Name,
                Monitor_Log__c.All_Module__c,
                Monitor_Log__c.Apex_Class__c,
                Monitor_Log__c.Concern__c,
                Monitor_Log__c.Concern_Person__c,    
                Monitor_Log__c.Data_Source__c,
                Monitor_Log__c.Date_Time__c,   
                Monitor_Log__c.Error_Message__c,
                Monitor_Log__c.Except_Module_Log__c,
                Monitor_Log__c.External_System_Name__c,
                Monitor_Log__c.Headers__c,
                Monitor_Log__c.Keep_log_for_last_X_days__c,    
                Monitor_Log__c.Logging_Type__c,
                Monitor_Log__c.Loggin_User__c,
                Monitor_Log__c.Login_User_Name__c	,
                Monitor_Log__c.Method__c,
                Monitor_Log__c.Module__c,
                Monitor_Log__c.Notification__c,
                Monitor_Log__c.Notification_Email__c,    
                Monitor_Log__c.Purged_file_Name__c,
                Monitor_Log__c.Purged_Status__c,   
                Monitor_Log__c.Purging_Mode__c,
                Monitor_Log__c.Purging_Schedule__c	,
                Monitor_Log__c.RecordId__c,
                Monitor_Log__c.Record_Type__c,
                Monitor_Log__c.ReloadStatus__c,    
                Monitor_Log__c.Remote_Address__c,
                Monitor_Log__c.Request_JSON__c,      
                Monitor_Log__c.Request_URL__c,
                Monitor_Log__c.Response_JSON__c	,
                Monitor_Log__c.Schedule_Job_Id__c,
                Monitor_Log__c.Status__c,
                Monitor_Log__c.Status_Code__c,    
                Monitor_Log__c.Terms_Condition__c,
                Monitor_Log__c.Type_Of_Integration__c
                };
                    }

}