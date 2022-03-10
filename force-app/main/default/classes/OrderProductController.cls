/**
 * Created by Omer on 18/02/2022.
 */

public with sharing class OrderProductController {

    @AuraEnabled
    public static List<OrderItem> getOrderItems(Id orderId, String sortBy, String sortDirection) {
        String query = '{0} {1} {2} {3}';
        String querySelect = 'SELECT Id,Product2.Name,UnitPrice,Quantity,TotalPrice';
        String queryFrom = 'FROM OrderItem';
        String queryWhere = 'WHERE Id!=NULL ';
        String queryOrder = '';
        
        queryWhere += 'AND OrderId=:orderId';
        if (String.isNotBlank(sortBy) && String.isNotBlank(sortDirection)){
            String internalSortBy = sortBy == 'ProductName' ? 'Product2.Name' : sortBy;
            queryOrder = 'ORDER BY ' + internalSortBy + ' ' + sortDirection;
        }

        query = String.format(query, new List<String>{
                querySelect,
                queryFrom,
                queryWhere,
                queryOrder
        });
        System.debug(query);
        return Database.query(String.escapeSingleQuotes(query));
    }

    @AuraEnabled
    public static Order getOrder(Id orderId) {
        return [
                SELECT Id,Status
                FROM Order
                WHERE Id = :orderId
        ];
    }

    @AuraEnabled
    public static OrderActivationResult activateOrder(Id orderId) {

        OrderService.OrderServiceIntegrationResult orderServiceIntegrationResult = OrderService.sendOrderToExternalSystem(orderId);

        OrderActivationResult orderActivationResult = new OrderActivationResult();
        orderActivationResult.message = orderServiceIntegrationResult.message;
        orderActivationResult.isSuccess = orderServiceIntegrationResult.isSuccess;
        if (orderActivationResult.isSuccess) {
            orderActivationResult.message = System.Label.OrderActivationIntegrationSuccessMessage;
        }

        Order order = new Order(Id = orderId);
        if (orderServiceIntegrationResult.isSuccess) {
            order.Status = 'Activated';
            //order.IntegrationStatus__c = 'Success';
            update order;
        } else {
            //order.IntegrationStatus__c = 'Fail';
            //update order;
        }

        return orderActivationResult;
    }

    public class OrderActivationResult {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public String message { get; set; }
    }
}