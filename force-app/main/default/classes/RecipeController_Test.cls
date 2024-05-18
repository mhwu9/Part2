@IsTest
private class RecipeController_Test {
    @IsTest
    static void testTestFactoryGenerateRecipesWithIngredients() {
        List<Recipe__c> listRecipe;
        List<Ingredient__c> listIngredient;
        TestRecipeFactory.generateRecipesWithIngredients(5);
        Test.startTest();
            listRecipe = [SELECT Id FROM Recipe__c];
            listIngredient = [SELECT Id FROM Ingredient__c];
        Test.stopTest();
        Assert.areEqual(5,listRecipe.size(),'Expected 5 Recipes');
        Assert.areEqual(13,listIngredient.size(),'Expected 13 Ingredients');
    }
}