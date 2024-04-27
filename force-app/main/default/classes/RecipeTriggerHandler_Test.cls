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

/* changed requirements Week 6
    @IsTest
    static void missingValuesCheckTestFull() {
        List<Recipe__c> testRecipeList = new List<Recipe__c> ();
        
        Recipe__c testRecipe0 = new Recipe__c (
            Name = 'Test All Blank Recipe'
        );
        testRecipeList.add(testRecipe0);

        Recipe__c testRecipe1 = new Recipe__c (
            Name = 'Test Units Blank Recipe',
            Active_Time__c = 1,
            Servings__c = 4,
            Description__c = 'This is the test recipe.'
        );
        testRecipeList.add(testRecipe1);

        Recipe__c testRecipe2 = new Recipe__c (
            Name = 'Test Active Time Blank Recipe',
            Active_Time_Units__c = 'Hours',
            Servings__c = 4,
            Description__c = 'This is the test recipe.'
        );
        testRecipeList.add(testRecipe2);

        Recipe__c testRecipe3 = new Recipe__c (
            Name = 'Test Servings Blank Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Description__c = 'This is the test recipe.'
        );
        testRecipeList.add(testRecipe3);

        Recipe__c testRecipe4 = new Recipe__c (
            Name = 'Test Description Blank Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Servings__c = 4
        );
        testRecipeList.add(testRecipe4);

        Recipe__c testRecipe5 = new Recipe__c (
            Name = 'Test All Populated Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Servings__c = 4,
            Description__c = 'This is the test recipe.'
        );
        testRecipeList.add(testRecipe5);

        Test.startTest();
            INSERT testRecipeList;
        Test.stopTest();

        List<Recipe__c> reviewRecipeList = [SELECT ID, Draft__c FROM Recipe__c WHERE Id IN :testRecipeList];
        System.assertEquals(TRUE, reviewRecipeList[0].Draft__c, 'Expected record missing values to be marked as draft');
        System.assertEquals(TRUE, reviewRecipeList[1].Draft__c, 'Expected record missing values to be marked as draft');
        System.assertEquals(TRUE, reviewRecipeList[2].Draft__c, 'Expected record missing values to be marked as draft');
        System.assertEquals(TRUE, reviewRecipeList[3].Draft__c, 'Expected record missing values to be marked as draft');
        System.assertEquals(TRUE, reviewRecipeList[4].Draft__c, 'Expected record missing values to be marked as draft');
        System.assertEquals(FALSE, reviewRecipeList[5].Draft__c, 'Expected record with all values to not be marked as draft');
    }
*/

    @IsTest
    static void missingValuesCheckTestNegative() {
        List<Recipe__c> testRecipeList = new List<Recipe__c> ();
        
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test All Blank Recipe'
        );
        testRecipeList.add(testRecipe);
        try {
            Test.startTest();
                INSERT testRecipeList;
                Assert.fail('Should have thrown exception.');
            Test.stopTest();
            }
        catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
            }
    }

    @IsTest
    static void missingValuesCheckTestPositive() {
        List<Recipe__c> testRecipeList = new List<Recipe__c> ();
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test All Populated Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Servings__c = 4,
            Description__c = 'This is the test recipe.'
        );
        testRecipeList.add(testRecipe);

        Test.startTest();
            INSERT testRecipeList;
        Test.stopTest();

        List<Recipe__c> reviewRecipeList = [SELECT ID, Draft__c FROM Recipe__c WHERE Id IN :testRecipeList];
        System.assertEquals(1, reviewRecipeList.size(), 'Expected record with all values to not throw exception and be found');
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
        System.assertEquals('Simple', reviewRecipe.Complexity__c, 'Expected Complexity to be Simple');
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
        System.assertEquals('Moderate', reviewRecipe.Complexity__c, 'Expected Complexity to be Moderate');
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
        System.assertEquals('Difficult', reviewRecipe.Complexity__c, 'Expected Complexity to be Difficult');
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

    @IsTest
    static void createReviewTestNegative() {
        Recipe__c testRecipe = new Recipe__c (
            Name = 'Test Draft Recipe',
            Active_Time_Units__c = 'Hours',
            Active_Time__c = 1,
            Description__c = 'This is the test draft recipe.'
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

        System.assertEquals(0,taskList.size(),'There should be no task because recipe is still in draft.');
    }
}