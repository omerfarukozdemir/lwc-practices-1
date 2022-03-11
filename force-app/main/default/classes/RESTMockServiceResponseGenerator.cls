/**
 * Created by Omer on 21/02/2022.
 */

@IsTest
public class RESTMockServiceResponseGenerator implements HttpCalloutMock {


    Integer statusCode;

    public RESTMockServiceResponseGenerator(Integer statusCode) {
        this.statusCode = statusCode;
    }

    public HttpResponse respond(HttpRequest req) {

        
        Map<String, Order_Request__mdt> requestURLs = UtilityController.getAllOrderRequestMDT();
        Order_Request__mdt methodDetail = requestURLs.get('Method1');

        HttpResponse response = new HttpResponse();
        System.debug(req.getEndpoint());
        if (req.getMethod() == methodDetail.HTTP_Method__c && req.getEndpoint().contains('callout:OrderExternalSystemNamedCredential/' + methodDetail.ServiceURL__c)) {
            response = new HttpResponse();
            //response.setBody(JSON.serialize(data));
            response.setStatusCode(statusCode);
            return response;
        } else {
            System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
            return null;
        }
    }

}