public with sharing class WeekTwoHomework {
    public static void taskAContactsAccountNameIndustry() {
        //Get a list of Contacts and their Account Name and Industry
        List<Contact> contactList = [
            SELECT FirstName, LastName, Account.Name, Account.Industry FROM Contact];
        //Create a loop of Contacts to loop through the above contactList, printing the name, account name, and industry for each
        for (Contact ii: contactList) {
            System.debug('Contact ' + ii.FirstName + ' ' + ii.LastName + ' is from Account ' + ii.Account.Name + ' and Industry ' + ii.Account.Industry);
        }
    }

    public static void taskBAccountsClosedWonOpps() {
        /*Get a list of Accounts and their closed-won Opportunities in a subquery. 
        Note, I decided to get only Accounts that have closed-won Opportunities; if you want all Accounts, leave the WHERE id part off) */
        List<Account> accountsAndClosedWonOpps = [
            SELECT Name, (SELECT Name FROM Opportunities) FROM Account 
            WHERE id IN (SELECT accountId FROM Opportunity WHERE IsWon = TRUE)];
        //Create a loop of Accounts to loop through and display their closed-won Opportunities
        for (Account aa: accountsAndClosedWonOpps) {
            //First print the Account
            System.debug('Account ' + aa.Name + ' has the following closed-won Opportunities: ');
            //Then loop and print the Opportunities
            for (Opportunity oo: aa.Opportunities) {
                System.debug('Opportunity: ' + oo.Name);
            }
        }
    }
    public static void taskCOpportunityMap() {
        //Create a new map, then place the SOQL queried Opportunities into the map
        Map<Id, Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id, Name FROM Opportunity]);
        System.debug(opportunityMap);
    }
    public static void taskDCountOpenOpps{
        Integer countOpenOpps = [
            SELECT COUNT() from Opportunity WHERE IsClosed = TRUE];
        System.debug('There are ' + countOpenOpps + ' open Opportunities.');    
    }
}