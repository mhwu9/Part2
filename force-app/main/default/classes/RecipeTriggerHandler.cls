public with sharing class RecipeTriggerHandler {

    //Recursion control
    static Boolean hasRunOnce = false;

    //Instantiating Class variables
    List<Recipe__c> newRecipeList;

    //Constructor to assign Trigger variables to Class variables
    public RecipeTriggerHandler(List<Recipe__c> newRecipeList) {
        this.newRecipeList = newRecipeList; 
    }

    //Part of recursion control
    public void handleBeforeInsert() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        missingValuesCheck();
        complexityRating();
        hasRunOnce = false;  
    }

    public void handleBeforeUpdate() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        missingValuesCheck();
        complexityRating();
        hasRunOnce = false; 
    }

    public void handleAfterInsert() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        //nothing in particular to do here; but the exercise called for an After Insert trigger so I've set it to go here
        hasRunOnce = false;  
    }

    public void handleAfterUpdate() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        createReview();
        hasRunOnce = false; 
    }

    public void missingValuesCheck() {
        for (Recipe__c rr1 : this.newRecipeList) {
            if(rr1.Name == null || rr1.Active_Time__c == null || rr1.Description__c == null || rr1.Active_Time_Units__c == null || rr1.Servings__c == null) {
                rr1.Draft__c = TRUE;
            }
        }
    }

    public void complexityRating() {
        for (Recipe__c rr2 : this.newRecipeList) {
            Integer intComplexity = HelperFunctions.rateRecipeComplexity(rr2);
                if(intComplexity == 3) {
                    rr2.Complexity__c = 'Difficult';
                }
                else if (intComplexity == 2) {
                    rr2.Complexity__c = 'Moderate';
                }
                else if (intComplexity == 1) {
                    rr2.Complexity__c = 'Simple';
                }
        //no need for DML because this is a Before action
        }
    }

    public void createReview() {
        List<Cookbook__c> listCookbooks = new List<Cookbook__c>([SELECT Id, OwnerId FROM Cookbook__c WHERE Id IN (SELECT Cookbook__c FROM Recipe_Usage__c WHERE Recipe__r.Draft__c = FALSE AND Recipe__r.Id IN : this.newRecipeList)]);
        List<Task> listTaskstoCreate = new List<Task>();

        for(Cookbook__c cb : listCookbooks) {
            Task varTask = new Task(
                OwnerId = cb.OwnerId,
                ActivityDate = System.Today() + 7,
                Subject = 'Review updated recipe(s) for your cookbook',
                WhatId = cb.Id
            );
            listTaskstoCreate.add(varTask);
        }
        if(listTaskstoCreate.size() > 0) {
        INSERT listTaskstoCreate;
        }
    }
}