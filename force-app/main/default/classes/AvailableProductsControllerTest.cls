/**
 * Created by Omer on 21/02/2022.
 */

@IsTest
private class AvailableProductsControllerTest {

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
    static void test() {
        Order order = [SELECT Id, (SELECT Id,Product2Id FROM OrderItems) FROM Order LIMIT 1];
        List<String> product2Ids = new List<String>();
        for (OrderItem orderItem : order.OrderItems) {
            product2Ids.add(orderItem.Product2Id);
        }
        Test.startTest();
        {
            AvailableProductsController.AvailableProductListResult result = AvailableProductsController.getAvailableProductList(order.Id, 5, product2Ids);
            System.assertEquals(1, result.totalRecordSize);
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateOrderItems() {

        Account account = [SELECT Id FROM Account LIMIT 1];
        Pricebook2 customPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = FALSE];
        Order order = new Order();
        order.AccountId = account.Id;
        order.Status = 'Draft';
        order.Pricebook2Id = customPriceBook.Id;
        order.EffectiveDate = Date.today();
        insert order;

        List<PricebookEntry> pricebookEntries = [SELECT Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :customPriceBook.Id];

        Test.startTest();
        {
            AvailableProductsController.updateOrderItems(order.Id, pricebookEntries);
            List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id];
            System.assertEquals(1, orderItems.size());
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetPriceBooks() {
        Test.startTest();
        {
            List<Pricebook2> pricebook2s = AvailableProductsController.getPriceBooks();
            System.assertEquals(2, pricebook2s.size());
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetOrder() {
        Order orderRecord = [SELECT Id FROM Order LIMIT 1];
        Test.startTest();
        {
            Order foundOrder = AvailableProductsController.getOrder(orderRecord.Id);
            System.assertEquals(orderRecord.Id, foundOrder.Id);
        }
        Test.stopTest();
    }

    @IsTest
    static void testSetPriceBook() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        Pricebook2 customPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = FALSE];
        Order order = new Order();
        order.AccountId = account.Id;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        insert order;
        Test.startTest();
        {
            AvailableProductsController.setPriceBook(order.Id, customPricebook.Id);
            order = [SELECT Id,Pricebook2Id FROM Order WHERE Id = :order.Id];
            System.assertEquals(customPricebook.Id, order.Pricebook2Id);
        }
        Test.stopTest();
    }

    @isTest
    static void describeLabelsTest(){
        Boolean TestOk = AvailableProductsController.describeLabels();
        system.assert(TestOk == true);
    }
}