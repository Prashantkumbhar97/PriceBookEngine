/**
 * @description       : This class show all Query of Price Book Entry Object.                                          
 * @author            : prashant.kumbhar@skinternational.com
 * @last modified on  : 10-11-2023
 * @last modified by  :  prashant.kumbhar@skinternational.com
**/

public without Sharing class PriceBookEntrySelector extends LibSObjectSelector {

public Schema.SObjectType getSObjectType(){
    return PricebookEntry.SObjectType;
}

/**
* @description:This method is used to Define all price Book Entry Fields.
* @return List<Schema.SObjectField>
*/
public List<Schema.SObjectField> getSObjectFieldList(){
    return new List<Schema.SObjectField> {
        PricebookEntry.Id,
            PricebookEntry.Name,
            PricebookEntry.Product2Id,
            PricebookEntry.Pricebook2Id,
                PricebookEntry.IsActive,
                PricebookEntry.UnitPrice    
                 };
                   
               }
    
/**
* @description:This method is used to get Standard Price Book Entry.
* @param  standPriceBookId: Standard price Book Id
* @param  productId: Product Id to retrive Data.
* @return List<PricebookEntry>
*/           
    public List<PricebookEntry> getStandardPriceBookEntry(Id standPriceBookId,Id productId){
        LibQueryFactory query = newQueryFactory();
        query.setCondition('Pricebook2Id=:standPriceBookId And Product2Id=:productId And IsActive = true');
        System.debug('Query is'+query.toSOQL());
        return Database.query( query.toSOQL());    
    }
    
}