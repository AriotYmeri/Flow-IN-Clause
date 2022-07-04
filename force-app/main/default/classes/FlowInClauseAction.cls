public with sharing class FlowInClauseAction {
    @invocableMethod(label='In Clause Action')
    public static List<List<SObject>> InClauseSOQL(List<Input> inputs){
        List<List<SObject>> listOfListOfQueriedRecords = new List<List<SObject>>();
        List<Id> idsFromCollectionToCheck = new List<Id>();
        for(Input input : inputs){
            for(SObject so : input.collectionToCheck){
                idsFromCollectionToCheck.add(so.Id);
            }
            //create query
            try{
                String query = 'SELECT '+input.fieldsToQuery+' FROM '+input.objectToQuery+' WHERE '+input.filter+' AND '+input.fieldToRelateToCollection+' IN : idsFromCollectionToCheck';
                System.debug(query);
                List<SObject> queriedRecords = Database.query(query);
                system.debug(queriedRecords);
                listOfListOfQueriedRecords.add(queriedRecords);
                idsFromCollectionToCheck.clear();
            }catch(Exception e){
                System.debug('Query not valid, please check input in the Action! Error--'+e.getMessage());
            }
        }
        return listOfListOfQueriedRecords;
    }

    public class Input{
        @invocableVariable(label='fields to query' descirption='separate each field with comma' required=true)
        public String fieldsToQuery;
        
        @invocableVariable(required=true)
        public String objectToQuery;

        @invocableVariable
        public String filter;//example: Amount__c > 100 and Id IN (collectionToCheck)

        @invocableVariable(label='field to relate to collection' required=true)
        public String fieldToRelateToCollection;

        @invocableVariable(required=true)
        public List<SObject> collectionToCheck;
    }
}
