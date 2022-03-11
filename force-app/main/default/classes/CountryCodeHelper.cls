public class CountryCodeHelper {
  public static string getCountryCode(String country) {
    Country_Code__mdt codes = UtilityController.getCountryCodeMDTByName(country);
    return codes.Country_Code__c;
  }
}