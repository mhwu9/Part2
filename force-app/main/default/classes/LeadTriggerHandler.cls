public with sharing class LeadTriggerHandler {

    //I referenced the AccountTrigger and AccountTriggerHandler structure as a reference
    
    //Recursion control
    static Boolean hasRunOnce = false;

    //Instantiating Class variables
    List<Lead> newLeadList;
    Map<ID, Lead> oldLeadMap;
    List<Lead> actionLeadList = new List<Lead>();

    //Constructor to assign Trigger variables to Class variables
    public LeadTriggerHandler(List<Lead> newLeadList, Map<Id,Lead> oldLeadMap) {
        this.newLeadList = newLeadList;
        this.oldLeadMap = oldLeadMap;
    }

    //Part of recursion control
    public void handleAfterInsert() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        //No need to assess whether or not to create a Task, jump straight to it
        actionLeadList = newLeadList;
        createTask();
        hasRunOnce = false;  
    }

    //Part of recursion control
    public void handleAfterUpdate() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        //Needs to assess if the Lead's Product Interest has changed
        checkInterestChange();
        hasRunOnce = false; 
    }

    //After update records are assessed here
    //Can we reuse variables across methods safely? Is that the difference between a public and private one? I made the loop variables ll1 and ll2 to be safe
    public void checkInterestChange() {

        for (Lead ll1 : this.newLeadList) {
            if(ll1.ProductInterest__c != OldLeadMap.get(ll1.Id).ProductInterest__c) {
                actionLeadList.add(ll1);
            }
        }
        
        if(actionLeadList.size() > 0) {
            createTask();
        }
    }

    //The actual part that creates a task
    public void createTask() {

        List<Task> newTasks = new List<Task>();

        Task newTask = new Task();
        //not usually a static value but for the purposes of this exercise
            newTask.OwnerId = '005ak000002IhgUAAS';
            newTask.ActivityDate = System.today() + 7;

        for (Lead ll2 : this.actionLeadList) {
            newTask.WhoId = ll2.Id;

            if(ll2.ProductInterest__c == 'Cookbook Authorship') {
                newTask.Subject = 'Speak to potential author';
            }
            else if(ll2.ProductInterest__c == 'Cookbook Editing') {
                newTask.Subject = 'Add to list of editors';
            }
            else if(ll2.ProductInterest__c == 'Cookbook Photography') {
                newTask.Subject = 'Review portfolio';
            }
            else if(ll2.ProductInterest__c == 'Cookbook Distribution') {
                newTask.Subject = 'Assess distribution network';
            }
            else {
                newTask.Subject = 'Determine Product Interest';
            }
            newTasks.add(newTask);
        }
    
        //Null check
        if (newTasks.size() > 0) {
            INSERT newTasks;
        }
    }
}