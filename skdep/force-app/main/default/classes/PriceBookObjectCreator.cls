/**
 * @description       : This class Call various classes based on Meta Data.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public class PriceBookObjectCreator {
    
/**
* @description:This method is used to define class Name.
* @param  classType: Define various Class name from Class Type.
* @return IPriceBookCreator
*/
    public static IPriceBookCreator className(String classType){
        PriceBookEntry__mdt eprice=PriceBookEntry__mdt.getInstance(classType);
        Type t=Type.forName(eprice.Class_Name__c);
        IPriceBookCreator subscription=(IPriceBookCreator)t.newInstance();
        return subscription; 
    }
}