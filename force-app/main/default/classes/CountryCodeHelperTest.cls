@IsTest
public class CountryCodeHelperTest {
    @IsTest
    public static void CountryCodeHelperTest() {
        Test.startTest();
        UtilityController.getCountryCodeMDTByName('TR');
        Test.stopTest();
    }
}
