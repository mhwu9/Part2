trigger LeadTrigger on Lead (after insert, after update) {
    
    //I'm not quite sure about the pros and cons about instantiating the trigger versus passing in the values
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