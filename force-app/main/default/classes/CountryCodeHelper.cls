public class CountryCodeHelper {
  public static string getCountryCode(String country) {
    Country_Code__mdt codes = Country_Code__mdt.getInstance(country);
    return codes.Country_Code__c;
  }
}