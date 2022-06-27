public with sharing class AccountController {

    @AuraEnabled
    public static List<AccountListModel> listAccounts(){
        try {
            List<AccountListModel> response = new List<AccountListModel>();
            for (Account account: new AccountSelector().getAccounts()){
                response.add(new AccountTransformer().transform(account));
            }
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class AccountListModel{
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String AccountNumber {get;set;}
        @AuraEnabled public String Site {get;set;}
        @AuraEnabled public String Phone {get;set;}

        public AccountListModel(Id id, String Name, String AccountNumber, String Site, String Phone){
            this.id = id;
            this.Name = Name;
            this.AccountNumber = AccountNumber;
            this.Site = Site;
            this.Phone = Phone;
        }
    }

    public class AccountTransformer{
        public AccountListModel transform(Account account){
            return new AccountListModel(account.Id, account.Name, account.AccountNumber, account.Site, account.Phone);
        }
    }
}
