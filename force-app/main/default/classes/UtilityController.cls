public class UtilityController {
    public static Map<String, Order_Request__mdt> getAllOrderRequestMDT(){
        Map<String, Order_Request__mdt> mapOfRecords = new Map<String, Order_Request__mdt>();

        Order_Request__mdt mdt = new Order_Request__mdt();
        mdt.DeveloperName = 'Method1';
        mdt.HTTP_Method__c = 'POST';
        mdt.ServiceURL__c = 'test';
        
        mapOfRecords.put('Method1', mdt);
        return mapOfRecords;
    }

    public static Country_Code__mdt getCountryCodeMDTByName(String name){
        Country_Code__mdt mdt = new Country_Code__mdt();
        mdt.DeveloperName = name;
        mdt.Country_Code__c = name;
        return mdt;
    }
}
