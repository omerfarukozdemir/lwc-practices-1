public with sharing class AccountSelector {
    
    public List<Account> getAccounts(){
        //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_with_security_enforced.htm
        return [select Id, AccountNumber, Name, Site, Phone from Account WITH SECURITY_ENFORCED ORDER BY LastModifiedDate desc];
    }
}
