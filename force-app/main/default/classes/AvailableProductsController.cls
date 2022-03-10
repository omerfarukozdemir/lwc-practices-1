/**
 * Created by Omer on 18/02/2022.
 */

public with sharing class AvailableProductsController {

    @AuraEnabled
    public static AvailableProductListResult getAvailableProductList(Id orderId, Integer recordLimit, List<String> showedProductIds) {
        Order order = [
                SELECT Id,Pricebook2Id, (
                        SELECT Id,Product2Id,PricebookEntryId
                        FROM OrderItems
                )
                FROM Order
                WHERE Id = :orderId
        ];

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        List<PricebookEntry> existPriceBookEntries = getOrderItemPriceBookEntries(orderId, recordLimit, showedProductIds);
        if (!existPriceBookEntries.isEmpty()) {
            pricebookEntries.addAll(existPriceBookEntries);
        }
        if (existPriceBookEntries.size() != 0 && existPriceBookEntries.size() < recordLimit) {
            recordLimit = recordLimit - existPriceBookEntries.size();
        }

        List<PricebookEntry> newPriceBookEntries = getPricebookEntries(order, recordLimit, showedProductIds);
        if (!newPriceBookEntries.isEmpty()) {
            pricebookEntries.addAll(newPriceBookEntries);
        }

        Integer totalRecordSize = getTotalRecordSize(order, recordLimit, showedProductIds);
        AvailableProductListResult result = new AvailableProductListResult();
        result.totalRecordSize = totalRecordSize;
        result.entries = pricebookEntries;

        System.debug('result: ' + result);

        return result;
    }

    private static Integer getTotalRecordSize(Order order, Integer recordLimit, List<String> showedProductIds) {
        String query = '{0} {1} {2}';
        String querySelect = 'SELECT Count(Id) totalRecordSize';
        String queryFrom = ' FROM PriceBookEntry';
        String queryWhere = 'WHERE Id!=NULL ';
        Id priceBook2Id = order.Pricebook2Id;
        queryWhere += 'AND PriceBook2Id=:priceBook2Id ';
        queryWhere += 'AND IsActive=TRUE';

        query = String.format(query, new List<String>{
                querySelect,
                queryFrom,
                queryWhere
        });
        System.debug(query);
        List<AggregateResult> countResults = Database.query(String.escapeSingleQuotes(query));
        Integer totalRecordSize = 0;
        if (countResults != null && !countResults.isEmpty()) {
            totalRecordSize = (Integer) countResults.get(0).get('totalRecordSize');
        }
        System.debug(totalRecordSize);
        return totalRecordSize;
    }

    private static List<PricebookEntry> getPricebookEntries(Order order, Integer recordLimit, List<String> showedProductIds) {
        String query = '{0} {1} {2} {3}';
        String querySelect = 'SELECT Id,Name,UnitPrice,Product2Id,PriceBook2Id';
        String queryFrom = ' FROM PriceBookEntry';
        String queryWhere = 'WHERE Id!=NULL ';
        String queryLimit = 'LIMIT :recordLimit';

        Id priceBook2Id = order.Pricebook2Id;
        queryWhere += 'AND PriceBook2Id=:priceBook2Id ';

        Set<Id> productIds = new Set<Id>();
        if (order.OrderItems != null && !order.OrderItems.isEmpty()) {
            for (OrderItem orderItem : order.OrderItems) {
                productIds.add(orderItem.Product2Id);
            }
        }

        if (showedProductIds != null && !showedProductIds.isEmpty()) {
            for (Id showProductId : showedProductIds) {
                productIds.add(showProductId);
            }
        }

        if (!productIds.isEmpty()) {
            queryWhere += 'AND Product2Id NOT IN : productIds';
        }


        query = String.format(query, new List<String>{
                querySelect,
                queryFrom,
                queryWhere,
                queryLimit
        });
        System.debug(query);
        List<PricebookEntry> pricebookEntries = Database.query(String.escapeSingleQuotes(query));
        return pricebookEntries;
    }

    private static List<PricebookEntry> getOrderItemPriceBookEntries(Id orderId, Integer recordLimit, List<String> showedProductIds) {
        List<PricebookEntry> orderItemPricebookEntries = new List<PricebookEntry>();

        String query = '{0} {1} {2} {3}';
        String querySelect = 'SELECT Id,PricebookEntry.Id,PriceBookEntry.PriceBook2Id,PricebookEntry.Product2Id,PricebookEntry.Name,PricebookEntry.UnitPrice';
        String queryFrom = 'FROM OrderItem';
        String queryWhere = 'WHERE Id!=NULL ';

        String queryLimit = 'LIMIT :recordLimit ';

        queryWhere += 'AND OrderId=:orderId ';

        if (showedProductIds != null && !showedProductIds.isEmpty()) {
            List<String> showedProductIds1 = showedProductIds;
            queryWhere += 'AND Product2Id NOT IN :showedProductIds1';
        }

        query = String.format(query, new List<String>{
                querySelect,
                queryFrom,
                queryWhere,
                queryLimit
        });

        System.debug(query);
        List<OrderItem> orderItems = Database.query(String.escapeSingleQuotes(query));
        for (OrderItem orderItem : orderItems) {
            orderItemPricebookEntries.add(orderItem.PricebookEntry);
        }
        return orderItemPricebookEntries;
    }

    @AuraEnabled
    public static Order getOrder(Id orderId) {
        return [
                SELECT Id,Pricebook2Id,Status
                FROM Order
                WHERE Id = :orderId
        ];
    }

    @AuraEnabled
    public static List<Pricebook2> getPriceBooks() {
        return [
                SELECT Id,Name
                FROM Pricebook2
                WHERE IsActive = TRUE
        ];
    }

    @AuraEnabled
    public static void updateOrderItems(Id orderId, List<PricebookEntry> selectedRows) {

        Map<Id, OrderItem> productToOrderItemMap = new Map<Id, OrderItem>();
        List<OrderItem> orderItemsToUpsert = new List<OrderItem>();

        List<OrderItem> orderItems = [
                SELECT Id,Product2Id,Quantity
                FROM OrderItem
                WHERE OrderId = :orderId
        ];
        if (!orderItems.isEmpty()) {
            for (OrderItem orderItem : orderItems) {
                productToOrderItemMap.put(orderItem.Product2Id, orderItem);
            }
        }

        for (PricebookEntry pricebookEntry : selectedRows) {
            OrderItem orderItem = productToOrderItemMap.get(pricebookEntry.Product2Id);
            if (orderItem == null) {
                orderItem = new OrderItem();
                orderItem.OrderId = orderId;
                orderItem.UnitPrice = pricebookEntry.UnitPrice;
                orderItem.PricebookEntryId = pricebookEntry.Id;
                orderItem.Quantity = 1;
            } else {
                orderItem.Quantity++;
            }
            orderItemsToUpsert.add(orderItem);
        }
        if (!orderItemsToUpsert.isEmpty()) {
            upsert orderItemsToUpsert;
        }
    }

    @AuraEnabled
    public static void setPriceBook(Id orderId, Id selectedPriceBook2Id) {
        System.debug('orderId: ' + orderId);
        System.debug('selectedPriceBook2Id: ' + selectedPriceBook2Id);
        Order order = new Order(Id = orderId, Pricebook2Id = selectedPriceBook2Id);
        try {
            update order;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    public class AvailableProductListResult {
        @AuraEnabled public Integer totalRecordSize { get; set; }
        @AuraEnabled public List<PricebookEntry> entries { get; set; }
    }

    //dummy method to create dependency for the labels
    public static Boolean describeLabels(){
        String l1 = Label.AvailableProductsAddProductButtonLabel;
        String l2 = Label.AvailableProductsCardLabel;
        String l3 = Label.AvailableProductsHideProductListButtonLabel;
        String l4 = Label.AvailableProductsListPriceColumnName;
        String l5 = Label.AvailableProductsProductNameColumnName;
        String l6 = Label.AvailableProductsShowProductListButtonLabel;
        String l7 = Label.OrderActivationIntegrationFailMessage;
        String l8 = Label.OrderActivationIntegrationSuccessMessage;
        String l9 = Label.OrderItemProductNameColumn;
        String l10 = Label.OrderItemQuantityColumnName;
        String l11 = Label.OrderItemTotalPriceColumnName;
        String l12 = Label.OrderItemUnitPriceColumnName;
        String l13 = Label.OrderProductsActivateButtonLabel;
        String l14 = Label.OrderProductsAddSuccess;
        String l15 = Label.OrderProductsCardLabel;
        String l16 = Label.OrderProductsSpinnerLoadingLabel;
        String l17 = Label.ShowToastEventFailMessageTitle;
        String l18 = Label.ShowToastEventSuccessMessageTitle;
        return true;
    }
}