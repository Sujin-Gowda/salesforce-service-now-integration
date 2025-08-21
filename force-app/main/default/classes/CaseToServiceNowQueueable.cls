public with sharing class CaseToServiceNowQueueable implements Queueable, Database.AllowsCallouts {
  private Set<Id> caseIds;

  public CaseToServiceNowQueueable(Set<Id> caseIds) {
    this.caseIds = caseIds;
  }

  public void execute(QueueableContext context) {
    Map<String, Object> response;
    Map<String, Object> result;
    List<Case> casesToSend = [
      SELECT Id, CaseNumber, Subject, Description
      FROM Case
      WHERE Id IN :caseIds
    ];

    for (Case case : casesToSend) {
      response = ServiceNowApiHandler.createIncident(
        generateIncidentBody(case.Subject, case.CaseNumber, case.Description)
      );

      if (response.get('result') != null) {
        result = (Map<String, Object>) response.get('result');
        case.ServiceNow_Incident_Id__c = String.valueOf(result.get('sys_id'));
      }
    }

    Database.update(casesToSend, false);
  }

  private static String generateIncidentBody(
    String subject,
    String caseNumber,
    String description
  ) {
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('short_description', subject + ' - ' + caseNumber);
    gen.writeStringField('description', description);
    gen.writeStringField('urgency', '1');
    gen.writeStringField('state', '1');
    gen.writeEndObject();
    return gen.getAsString();
  }
}
