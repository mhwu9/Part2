public inherited sharing class RecipeController {
    
    @AuraEnabled
    public static void addIngredient (String ingredientName, Decimal measurementAmount, String measurementType, ID recipeId) {
        //assigning passed in values to ingredient variable. Note to test that text is within character limits and values are types as expected, or to check for these
        Ingredient__c varIngredient = new Ingredient__c(
            Name = ingredientName,
            Measurement__c = measurementAmount,
            Measurement_Type__c = measurementType,
            Recipe__c = recipeId
        );
        if(varIngredient.Name != null) {
            INSERT varIngredient;
        }
    }

    @AuraEnabled
    public static List<Ingredient__c> generateGroceryList(ID recipeId) {
        //not putting a limit as someone would want to see all the ingredients... not putting this as a list either as only one ID is passed in
        return[SELECT
                Id,
                Name,
                Measurement__c,
                Measurement_Type__c,
                Notes__c,
                Recipe__c
            FROM Ingredient__c
            WHERE Recipe__c = :recipeId
            ORDER BY Name
        ];
    }

    @AuraEnabled
    public static List<Ingredient__c> scaleRecipeForServings (ID recipeId, Decimal desiredServings) {
        //SOQL query for the ingredient records
        List<Ingredient__c> listIngredient = [SELECT 
                                                Id,
                                                Name,
                                                Measurement__c,
                                                Measurement_Type__c,
                                                Notes__c, Recipe__c 
                                            FROM Ingredient__c 
                                            WHERE Recipe__c = :recipeId 
                                            ORDER BY Name];
        //loop through ingredients and multiply the measurement value by the desired servings
        for(Ingredient__c ii : listIngredient) {
            ii.Measurement__c = ii.Measurement__c * desiredServings;
        }
        return listIngredient;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Recipe__c> getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Recipe__c> searchRecipes(String searchTerm) {
        List<Recipe__c> recipes = new List<Recipe__c>();

        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            recipes = getAllRecipes();
        } else {
            // Prepare query parameters
            searchTerm = '%' + searchTerm + '%';

            // Execute search query
            recipes = [
                SELECT
                    Id,
                    Name,
                    Draft__c,
                    Active_Time__c,
                    Active_Time_Units__c,
                    Complexity__c,
                    Needs_Review__c,
                    Possible_Duplicate__c,
                    Season__c
                FROM Recipe__c
                WHERE Name LIKE :searchTerm
                ORDER BY Name
                LIMIT 50
            ];
        }

        System.debug('returning: ' + recipes);
        return recipes;
    }
}
