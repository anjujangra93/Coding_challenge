public with sharing class AccountController {
  
   @AuraEnabled(cacheable=true)
   public static List<AccountWrapper> getAccountsByIndustry( String searchKey, String sortBy, String sortDirection,String industry) {
      
       String query = 'SELECT Id, Name,Owner.Name,Phone,Website,AnnualRevenue  FROM Account';
       system.debug('query---'+query);
       if ( searchKey != null && searchKey != '' ) {
           String key = '%' + searchKey + '%';
           query += ' WHERE Name LIKE :key';
           query += ' AND industry =: industry';
       }
       if ( sortBy != null && sortDirection != null ) {
           query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
       }
       List<Account> lst_Accounts =  Database.query( query );
       List<AccountWrapper> lst_AccountWrapper = new List<AccountWrapper>();
       for (Account acc : lst_Accounts) {
           AccountWrapper wrapper = new AccountWrapper();
           wrapper.Id = acc.Id;
           wrapper.Name = acc.Name;
           wrapper.Website = acc.Website;
           wrapper.Phone = acc.Phone;
           wrapper.AnnualRevenue = acc.AnnualRevenue;
           wrapper.Owner = acc.Owner.Name;
           wrapper.URL = '/' + acc.Id;
           lst_AccountWrapper.add(wrapper);
       }
       return lst_AccountWrapper;
   }

   public class AccountWrapper {
       @AuraEnabled
       public string Id {get;set;}
       @AuraEnabled
       public string Name {get;set;}
       @AuraEnabled
       public string Website {get;set;}
       @AuraEnabled
       public string Phone {get;set;}
       @AuraEnabled
       public double AnnualRevenue {get;set;}
       @AuraEnabled
       public string Owner {get;set;}
       @AuraEnabled
       public string URL {get;set;}
   }
}
