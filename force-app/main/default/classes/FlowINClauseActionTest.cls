@isTest
public with sharing class FlowINClauseActionTest {
    public @TestSetup static void makeData(){
        List<Account> testAccountsToInsert = new List<Account>();
        List<Opportunity> testOpportunitiesToInsert = new List<Opportunity>();
        Account a1 = new Account(Name = 'acc1', Type = 'Prospect');
        Account a2 = new Account(Name = 'acc2', Type = 'Prospect');
        Account a3 = new Account(Name = 'acc3', Type = 'Customer - Direct');
        Account a4 = new Account(Name = 'acc4', Type = 'Prospect');
        testAccountsToInsert.add(a1);
        testAccountsToInsert.add(a2);
        testAccountsToInsert.add(a3);
        testAccountsToInsert.add(a4);
        insert testAccountsToInsert;
        Date d = Date.today();
        Opportunity o1 = new Opportunity(Name = 'oppty1', AccountId = a1.Id, StageName = 'Prospect', Amount = 100000, CloseDate = d);
        Opportunity o2 = new Opportunity(Name = 'oppty2', AccountId = a1.Id, StageName = 'Qualification', Amount = 130, CloseDate = d);
        Opportunity o3 = new Opportunity(Name = 'oppty3', AccountId = a2.Id, StageName = 'Prospect', Amount = 9980, CloseDate = d );
        Opportunity o4 = new Opportunity(Name = 'oppty4', AccountId = a2.Id, StageName = 'Prospect', Amount = 3232.12, CloseDate = d);
        Opportunity o5 = new Opportunity(Name = 'oppty5', AccountId = a3.Id, StageName = 'Qualification', Amount = 55323, CloseDate = d);
        Opportunity o6 = new Opportunity(Name = 'oppty6', AccountId = a3.Id, StageName = 'Prospect', Amount = 1234567, CloseDate = d);
        Opportunity o7 = new Opportunity(Name = 'oppty7', AccountId = a4.Id, StageName = 'Qualification', Amount = 2222, CloseDate = d);
        Opportunity o8 = new Opportunity(Name = 'oppty8', AccountId = a4.Id, StageName = 'Prospect', Amount = 55236, CloseDate = d);
        testOpportunitiesToInsert.add(o1);
        testOpportunitiesToInsert.add(o2);
        testOpportunitiesToInsert.add(o3);
        testOpportunitiesToInsert.add(o4);
        testOpportunitiesToInsert.add(o5);
        testOpportunitiesToInsert.add(o6);
        testOpportunitiesToInsert.add(o7);
        testOpportunitiesToInsert.add(o8);
        insert testOpportunitiesToInsert;
    }

    @isTest
    public static void getOpptysOfProspectAccounts(){
        List<FlowINClauseAction.Input> listOfInputs = new List <FlowINClauseAction.Input>();

        String fieldsToQuery = 'Id, Name, Amount, StageName';
        String objectToQuery = 'Opportunity';
        String fieldToRelateToCollection = 'AccountId';
        List<Account> accountsToQuery = [SELECT id FROM Account WHERE Type = 'Prospect'];
        List<Id> collectionToCheck = new List<Id>();
        for(Account a : accountsToQuery){
            collectionToCheck.add(a.Id);
        }
        FlowInClauseAction.Input input = new FlowInClauseAction.Input();
        input.fieldsToQuery = fieldsToQuery;
        input.objectToQuery = objectToQuery;
        input.fieldToRelateToCollection = fieldToRelateToCollection;
        input.collectionToCheck = accountsToQuery;
        listOfInputs.add(input);
        
        String expectedQuery = 'SELECT '+fieldsToQuery+' FROM '+objectToQuery+' WHERE '+fieldToRelateToCollection+
        +' IN :collectionToCheck';
        System.debug(expectedQuery);
        List<Opportunity> expectedSOQLResult = Database.query(expectedQuery);

        Test.startTest();
        List<List<sObject>> actualResutLists = FlowINClauseAction.inClauseSOQL(listOfInputs);
        List<Sobject> actualResult = actualResutLists[0];
        System.assertEquals(expectedSOQLResult, actualResult);
        Test.stopTest();
    }

    @isTest
    public static void getBigAmmontOpptysOfDirectCustomers(){
        List<FlowINClauseAction.Input> listOfInputs = new List <FlowINClauseAction.Input>();

        String fieldsToQuery = 'Id, Name, Amount, StageName';
        String filter = 'Amount > 50000';
        String objectToQuery = 'Opportunity';
        Integer lim = 1;
        String fieldToRelateToCollection = 'AccountId';
        List<Account> accountsToQuery = [SELECT id FROM Account WHERE Type = 'Customer - Direct'];
        List<Id> collectionToCheck = new List<Id>();
        for(Account a : accountsToQuery){
            collectionToCheck.add(a.Id);
        }
        FlowInClauseAction.Input input = new FlowInClauseAction.Input();
        input.fieldsToQuery = fieldsToQuery;
        input.objectToQuery = objectToQuery;
        input.filter = filter;
        input.lim = lim;
        input.fieldToRelateToCollection = fieldToRelateToCollection;
        input.collectionToCheck = accountsToQuery;
        listOfInputs.add(input);
        
        String expectedQuery = 'SELECT '+fieldsToQuery+' FROM '+objectToQuery+' WHERE '+filter+' AND '+fieldToRelateToCollection+
        +' IN :collectionToCheck LIMIT '+lim;
        System.debug(expectedQuery);
        List<Opportunity> expectedSOQLResult = Database.query(expectedQuery);

        Test.startTest();
        List<List<sObject>> actualResutLists = FlowINClauseAction.inClauseSOQL(listOfInputs);
        List<Sobject> actualResult = actualResutLists[0];
        System.assertEquals(expectedSOQLResult, actualResult);
        Test.stopTest();

    }
    
    @isTest
    public static void testErrorQuery(){
        List<FlowINClauseAction.Input> listOfInputs = new List <FlowINClauseAction.Input>();

        String fieldsToQuery = 'Id, fieldThatDoesNotExistInThisObject, Amount, StageName';
        String filter = 'wrongField > 50000';
        String objectToQuery = 'Opportunity';
        Integer lim = 1;
        String fieldToRelateToCollection = 'AccountId';
        List<Account> accountsToQuery = [SELECT id FROM Account WHERE Type = 'Prospect'];
        List<Id> collectionToCheck = new List<Id>();
        for(Account a : accountsToQuery){
            collectionToCheck.add(a.Id);
        }
        FlowInClauseAction.Input input = new FlowInClauseAction.Input();
        input.fieldsToQuery = fieldsToQuery;
        input.objectToQuery = objectToQuery;
        input.filter = filter;
        input.lim = lim;
        input.fieldToRelateToCollection = fieldToRelateToCollection;
        input.collectionToCheck = accountsToQuery;
        listOfInputs.add(input);
        Test.startTest();
        List<List<sObject>> actualResutLists = FlowINClauseAction.inClauseSOQL(listOfInputs);
        Test.stopTest();

    }
}
