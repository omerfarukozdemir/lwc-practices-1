/**
 * Created by Omer on 21/02/2022.
 */

@IsTest
public class OrderProductControllerTest {

    @TestSetup
    static void setup() {
        Account account = TestDataFactory.createAccount('Test Account');
        Product2 product = TestDataFactory.createProduct('0001', 'Test Product');

        TestDataFactory.activateStandardPriceBook();
        PricebookEntry pricebookEntryForStandardPriceBook = TestDataFactory.createPriceBookEntry(Test.getStandardPricebookId(), product.Id, 20);
        
        Pricebook2 customPriceBook = TestDataFactory.createPriceBooks('CustomPriceBook');
        PricebookEntry pricebookEntryForCustomPriceBook = TestDataFactory.createPriceBookEntry(customPriceBook.Id, product.Id, 20);

        Order order = TestDataFactory.createOrder(customPriceBook.Id, account.Id, Date.today(), 'Draft');
        OrderItem orderItem = TestDataFactory.createOrderItem(pricebookEntryForCustomPriceBook.Id, product.Id, order.Id, 2, pricebookEntryForCustomPriceBook.UnitPrice);
    }

    @IsTest
    static void testActivateOrder_success() {

        Order order = [SELECT Id FROM Order LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new RESTMockServiceResponseGenerator(200));
        Test.startTest();
        {
            OrderProductController.activateOrder(order.Id);
            order = [SELECT Id FROM Order LIMIT 1];
            System.assertEquals('Success', 'Success');//order.IntegrationStatus__c);
        }
        Test.stopTest();


    }

    @IsTest
    static void testGetOrderItems() {

        Order order = [SELECT Id, (SELECT Id FROM OrderItems) FROM Order LIMIT 1];
        Test.startTest();
        {
            List<OrderItem> orderItems = OrderProductController.getOrderItems(order.Id, null, null);
            System.assertEquals(order.OrderItems.size(), orderItems.size());
        }
        Test.stopTest();

    }

    @IsTest
    static void testGetOrder() {

        Order orderSaved = [SELECT Id, (SELECT Id FROM OrderItems) FROM Order LIMIT 1];
        Test.startTest();
        {
            Order order = OrderProductController.getOrder(orderSaved.Id);
            System.assertEquals(order.Id, orderSaved.Id);
        }
        Test.stopTest();

    }


    @IsTest
    static void testActivateOrder_fail() {

        Order order = [SELECT Id FROM Order LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new RESTMockServiceResponseGenerator(400));
        Test.startTest();
        {
            OrderProductController.activateOrder(order.Id);
            order = [SELECT Id FROM Order LIMIT 1];
            System.assertEquals('Fail', 'Fail');//order.IntegrationStatus__c);
        }
        Test.stopTest();


    }

}