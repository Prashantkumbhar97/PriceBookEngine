/**
 * @description       : This is interface class for Monitor Class.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public interface IMonitor {
    
/**
* @description: Create Monitor record for Integration Class.
* @param headers: Used to store headers in Monitor Log.
* @param request: Used to store request in Monitor Log.
* @param response: Used to store response in Monitor Log.
* @param statusCode: Used to store StatusCode in Monitor Log.
* @param apexClass: Used to store apex class name in Monitor Log.
* @param recordId: Used to store recordId in Monitor Log.
* @param module: Used to store module name on which we are working like Account, Sales order etc.
* @param userId: Used to store logged in user information.
* @param message: Used to store error or success message in Monitor Log.
* @param typeOfIntegration: Used to store Which Type of Integration.
* @param method: Used to store method in Monitor Log.
* @param requestURL: Used to store url in Monitor Log.
* @param remoteAddress: Used to store remote Address in Monitor Log.
* @param headers: Used to store header in Monitor Log.
* @param dataSource: Used to store dataSource in Monitor Log.
* @param externalSystemName: Used to store externalSystemName in Monitor Log.
* @return void.
*/
  
void requestResponseLog(String request, String response,String statusCode,String apexClass,String recordId,String module,String userId,
                            String message,String typeOfIntegration,String method,String requestURL,String remoteAddress,String headers,
                            String dataSource,String externalSystemName);                            

/**
* @description: Create Monitor record for Normal class.
* @param apexClass: Used to store apex class name in Monitor Log.
* @param recordId: Used to store recordId in Monitor Log.
* @param module: Used to store module name on which we are working like Account, Sales order etc.
* @param userId: Used to store logged in user information.
* @param message: Used to store error or success message in Monitor Log.
* @param method: Used to store method in Monitor Log.
* @param headers: Used to store headers in Monitor Log.
* @return void.
*/

void log(String apexClass,String recordId,String module,String userId,String message,String headers);

/**
* @description: This method is used to create record in MonitorLog for Exception Handling 
* @param exObj: Used to store exception error in Monitor log.
* @param recordId: Used to store recordId in Monitor Log.
* @param request: Used to store http request in Monitor log.
* @param response: Used to  store http response in Monitor log.
* @param apexClass: Used to store apex class name in Monitor Log.
* @param module: Used to store module name on which we are working like Account, Sales order etc.
* @return void.
*/

void exceptionHandler(Exception exObj,String recordId, String request,String response,String apexClass,String module);

}