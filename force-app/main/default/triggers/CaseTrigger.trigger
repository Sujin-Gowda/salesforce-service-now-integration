trigger CaseTrigger on Case (after insert) {
    CaseTriggerHandler.handle();
}