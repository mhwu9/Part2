trigger RecipeTrigger on Recipe__c (before insert, before update, after insert, after update) {
    
    //Instantiate handler 
    RecipeTriggerHandler handler = new RecipeTriggerHandler(Trigger.new);
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            handler.handleBeforeInsert();
        }
        else if(Trigger.isUpdate) {
            handler.handleBeforeUpdate();
        }
    }
    
    else if(Trigger.isAfter) {
        //there isn't actually any purpose in the homework to having a After Insert, but the instructions do tell us to create one, so I've placed it in here
        if(Trigger.isInsert) {
            handler.handleAfterInsert();
        }
        else if(Trigger.isUpdate) {
            handler.handleAfterUpdate();
        }
    }
}