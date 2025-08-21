public with sharing class CaseTriggerHandler {
    
    public static void handle(){
        switch on Trigger.operationType {
            when AFTER_INSERT {
                sendToServiceNow(Trigger.newMap.keySet());
            }
        }
    }
    
    public static void sendToServiceNow(Set<Id> caseIds){
        System.enqueueJob(new CaseToServiceNowQueueable(caseIds));
    }
}