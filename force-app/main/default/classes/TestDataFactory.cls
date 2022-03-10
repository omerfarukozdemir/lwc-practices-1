/**
 * Created by Omer on 21/02/2022.
 */

@IsTest
public class TestDataFactory {

    public static Account createAccount(String name) {
        Account account = new Account();
        account.Name = name;
        insert account;
        return account;
    }

    public static Product2 createProduct(String productCode, String productName) {
        Product2 product = new Product2();
        product.Name = productName;
        product.ProductCode = productCode;
        insert product;
        return product;
    }

    public static Pricebook2 activateStandardPriceBook() {
        Pricebook2 standardPricebook2 = new Pricebook2(Id = Test.getStandardPricebookId());
        standardPricebook2.IsActive = true;
        update standardPricebook2;
        return standardPricebook2;
    }

    public static Pricebook2 createPriceBooks(String priceBookName) {
        Pricebook2 customPriceBook = new Pricebook2();
        customPriceBook.Name = priceBookName;
        customPriceBook.IsActive = true;
        insert customPriceBook;
        return customPriceBook;
    }

    public static PricebookEntry createPriceBookEntry(Id priceBookId, Id productId, Decimal UnitPrice) {
        PricebookEntry pricebookEntryForCustomPriceBook = new PricebookEntry();
        pricebookEntryForCustomPriceBook.Product2Id = productId;
        pricebookEntryForCustomPriceBook.Pricebook2Id = priceBookId;
        pricebookEntryForCustomPriceBook.UnitPrice = UnitPrice;
        pricebookEntryForCustomPriceBook.IsActive = true;
        insert pricebookEntryForCustomPriceBook;
        return pricebookEntryForCustomPriceBook;
    }

    public static Order createOrder(Id priceBookId, Id accountId, Date orderDate, String status) {
        Order order = new Order();
        order.AccountId = accountId;
        order.Status = status;
        order.Pricebook2Id = priceBookId;
        order.EffectiveDate = orderDate;
        insert order;
        return order;
    }

    public static OrderItem createOrderItem(Id priceBookId, Id productId, Id orderId, Decimal quantity, Decimal unitPrice) {
        OrderItem orderItem = new OrderItem();
        orderItem.PricebookEntryId = priceBookId;
        orderItem.UnitPrice = unitPrice;
        orderItem.Product2Id = productId;
        orderItem.Quantity = quantity;
        orderItem.OrderId = orderId;
        insert orderItem;
        return orderItem;
    }




}