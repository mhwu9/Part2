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
        hasRunOnce = false;  
    }

    public void handleBeforeUpdate() {
        if(hasRunOnce) {
            return;
        }
        hasRunOnce = true;
        missingValuesCheck();
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
        hasRunOnce = false; 
    }

    public void missingValuesCheck() {
        List<Recipe__c> listDraftRecipeUpdate = new List<Recipe__c>();
        for (Recipe__c rr1 : this.newRecipeList) {
            if(rr1.Name == null || rr1.Active_Time__c == null || rr1.Description__c == null || rr1.Active_Time_Units__c == null || rr1.Servings__c == null) {
                rr1.Draft__c = TRUE;
                listDraftRecipeUpdate.add(rr1);
            }
        }
        //null check before updating collection
        if(listDraftRecipeUpdate.size() > 0) {
            UPDATE listDraftRecipeUpdate;
        }
    }

    public void complexityRating() {
        List<Recipe__c> listRecipeComplexityUpdate = new List<Recipe__c>();
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
            listRecipeComplexityUpdate.add(rr2);
        }
        //null check before updating collection
        if(listRecipeComplexityUpdate.size() > 0) {
            UPDATE listRecipeComplexityUpdate;
        }
    }

    public void createReview() {
        List<Recipe__c> listNotDraftRecipes = new List<Recipe__c>();
        for (Recipe__c rr3 : this.newRecipeList) {
            if(rr3.Draft__c == FALSE) {
                listNotDraftRecipes.add(rr3);
            }
        }
        if(listNotDraftRecipes.size() > 0) {
            List<Task> listTaskstoCreate = new List<Task>();
            for (Recipe_Usage__c ru : [SELECT Id, Recipe__c, Cookbook__c FROM Recipe_Usage__c WHERE Recipe__c IN : listNotDraftRecipes]) {
                Task varTask = new Task(
                    OwnerId = ru.Cookbook__r.OwnerId,
                    ActivityDate = System.Today(),
                    Subject = 'Review updated recipe for your cookbook',
                    WhatId = ru.Recipe__r.Id
                );
                listTaskstoCreate.add(varTask);
            } 
            INSERT listTaskstoCreate;
        }
    }
}