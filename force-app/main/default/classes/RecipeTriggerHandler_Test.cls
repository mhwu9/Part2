@IsTest
private class RecipeTriggerHandler_Test {

    //still can't quite figure out how to test recursion check return. I did learn about @TestVisible, but how to trigger the return?
/*
    @IsTest
    static void handleBeforeInsert() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe'
        );
        Test.startTest();
        INSERT testRecipe;
        Boolean hasRunOnce = RecipeTriggerHandler.hasRunOnce;
        UPDATE testRecipe;
        System.assertEquals(TRUE, hasRunOnce, 'Expect has run once to be True');
        Test.stopTest();
    }
    
    @IsTest
    static void handleBeforeUpdate() {
        //test
    }

    @IsTest
    static void handleAfterInsert() {
        //test
    }

    @IsTest
    static void handleAfterUpdate() {
        //test
    }
*/

    @IsTest
    static void missingValuesCheckTest() {
        //could add more tests checking that each field separately being incomplete all result in draft
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe'
        );
        Test.startTest();
            INSERT testRecipe;
        Test.stopTest();
        Recipe__c reviewRecipe = [SELECT ID, Draft__c FROM Recipe__c WHERE Id = :testRecipe.Id];
        System.assertEquals(reviewRecipe.Draft__c, TRUE,'Expected record missing values to be marked as draft');
    }

    @IsTest
    static void complexityRatingTestSimple() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe',
            Active_Time_Units__c = 'Minutes',
            Active_Time__c = 5
        );
        Test.startTest();
            INSERT testRecipe;
        Test.stopTest();
        Recipe__c reviewRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE Id = :testRecipe.Id];
        System.assertEquals(reviewRecipe.Complexity__c, 'Simple','Expected Complexity to be Simple');
    }

    @IsTest
    static void complexityRatingTestModerate() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe',
            Servings__c = 7
        );
        Test.startTest();
            INSERT testRecipe;
        Test.stopTest();
        Recipe__c reviewRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE Id = :testRecipe.Id];
        System.assertEquals(reviewRecipe.Complexity__c, 'Moderate','Expected Complexity to be Moderate');
    }

    @IsTest
    static void complexityRatingTestDifficult() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1
        );
        Test.startTest();
            INSERT testRecipe;
        Test.stopTest();
        Recipe__c reviewRecipe = [SELECT ID, Complexity__c FROM Recipe__c WHERE Id = :testRecipe.Id];
        System.assertEquals(reviewRecipe.Complexity__c, 'Difficult','Expected Complexity to be Difficult');
    }

    @IsTest
    static void createReviewTestSuccessful() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Servings__c = 4,
            Description__c = 'This is the test recipe.'
        );
        INSERT testRecipe;
        
        Cookbook__c testCookBook = new Cookbook__c (
            Name = 'Test Cookbook'
        );
        INSERT testCookbook;

        Recipe_Usage__c testRecipeUsage = new Recipe_Usage__c (
            Recipe__c = testRecipe.Id,
            Cookbook__c = testCookbook.Id
        );
        INSERT testRecipeUsage;

        testRecipe.Contains_Allergins__c = TRUE;

        Test.startTest();
            UPDATE testRecipe;
        Test.stopTest();
        
        List<Task> taskList = [SELECT Id, WhatId, ActivityDate FROM Task];

        System.assertEquals(1,taskList.size(),'There should be one task.');
        System.assertEquals(testCookbook.id, taskList[0].WhatId, 'Task should be related to Cookbook');
        System.assertEquals(system.today()+7,taskList[0].ActivityDAte, 'Task should be due in 7 days');
    }
}