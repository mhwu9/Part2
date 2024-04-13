trigger LeadTrigger on Lead (after insert, after update) {
    
    LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.new, Trigger.oldMap);
    
    if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                handler.handleAfterInsert();
            }
            else if(Trigger.isUpdate) {
                handler.handleAfterUpdate();
            }
    }
}