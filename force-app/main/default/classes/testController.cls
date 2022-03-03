public with sharing class testController {
    @AuraEnabled
    public static List<Account> readAccounts(){
        try {
            return [SELECT Id FROM Account where AccountNumber != null LIMIT 5];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}