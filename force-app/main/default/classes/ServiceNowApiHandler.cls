public with sharing class ServiceNowApiHandler {
 
  public static Map<String, Object> createIncident(String bodyString) {
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:ServiceNow_NC/now/table/incident');
    request.setMethod('POST');
    request.setHeader('Content-type', 'application/json');
    request.setHeader('Accept', 'application/json');
    request.setBody(bodyString);
    try {
      HttpResponse response = new Http().send(request);
      if (response.getStatusCode() == 201) {
        return (Map<String, Object>) JSON.deserializeUntyped(
          response.getBody()
        );
      }
    } catch (CalloutException e) {
      System.debug(e.getMessage());
    }
    return new Map<String, Object>();
  }
}
