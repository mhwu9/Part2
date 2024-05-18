@isTest
public class TestRecipeFactory {
    //Final project Part 2 Method 1 to create and return a list of ingredient sObjects with dummy data, though I added a recipeId parameter
    public static List<Ingredient__c> generateIngredientsMemory(Integer numIngredients, Id recipeId){
        List<Ingredient__c> listIngredients = new List<Ingredient__c>();
        for(Integer i = 0; i < numIngredients; i++){
            Ingredient__c ing = new Ingredient__c(
                Name = 'Ingredient ' + i,
                Recipe__c = recipeId
                //add additional field values here
            );
            listIngredients.add(ing);
        }
        return listIngredients;
    }

    //Final project Part 2 Method 2 to create, insert, and return Ingredient SObjects
    public static List<Ingredient__c> generateIngredientsCreate(Integer numIngredients, Id recipeId){
        List<Ingredient__c> listIngredients = new List<Ingredient__c>();
        for(Integer i = 0; i < numIngredients; i++){
            Ingredient__c ing = new Ingredient__c(
                Name = 'Ingredient ' + i,
                Recipe__c = recipeId
                //add additional field values here
            );
            listIngredients.add(ing);
        }
        insert listIngredients;
        return listIngredients;
    }

    //Final project Part 2 Method 3 to create, insert, and return a list of Recipe SObjects
    public static List<Recipe__c> generateRecipesWithIngredients(Integer numRecipes){
        List<Recipe__c> listRecipes = new List<Recipe__c>();
        List<Ingredient__c> listAllIngredients = new List<Ingredient__c>();

        for (Integer i = 0; i < numRecipes; i++){
            Recipe__c rec = new Recipe__c(
                Name = 'Recipe ' + i,
                Active_Time__c = i,
                Description__c = 'Description ' + i,
                Active_Time_Units__c = 'Hours',
                Servings__c = i
            );
            listRecipes.add(rec);
        }
        insert listRecipes;

        Integer n1 = 1;
        for(Recipe__c rr : [SELECT Id, Name FROM Recipe__c]){
            System.debug('Iteration ' + n1 + ', ' + rr.Name);
            Integer n2 = Math.mod(n1,2);
                if(n2 == 0) {
                    System.debug('Is even');
                    listAllIngredients.addAll(generateIngredientsMemory(2,rr.Id));
                } else {
                    System.debug('Is odd');
                    listAllIngredients.addAll(generateIngredientsMemory(3,rr.Id));
                }
                n1++;
        }
        insert listAllIngredients;
        return listRecipes;
    }
}