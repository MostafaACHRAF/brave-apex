/**
 * @description       : Apex controller, to manage AccountContact relationships
 * @author            : mostafa.asharf
 * @group             : Apex domain badge
 * @last modified on  : 25-01-2023
 * @last modified by  : mostafa.asharf
 **/
public without sharing class AccountContactController {
  @AuraEnabled
  public static List<Record> getRecords(
    Integer numberOfRecords,
    String orderBy
  ) {
    List<AccountContactRelation> relations = [
      SELECT Id, ContactId, AccountId, Contact.Name, Account.Name
      FROM AccountContactRelation
      WITH SECURITY_ENFORCED
      ORDER BY Contact.Name
      LIMIT :numberOfRecords
    ];

    Map<Id, Record> contactIdToRecord = new Map<Id, Record>();

    for (AccountContactRelation relation : relations) {
      Record rec = new Record(
        relation.Contact.Name,
        relation.Account.Name,
        relation.ContactId,
        relation.AccountId
      );

      if (contactIdToRecord.containsKey(relation.contactId)) {
        rec = contactIdToRecord.get(relation.contactId);
        rec.incrementNbrOfAccounts();
      }

      contactIdToRecord.put(relation.contactId, rec);
    }

    List<Record> sortedRecords = sortRecords(
      contactIdToRecord.values(),
      orderBy
    );
    return sortedRecords;
  }

  private static List<Record> sortRecords(
    List<Record> records,
    String orderBy
  ) {
    switch on orderBy.toLowerCase() {
      when 'name' {
        return records;
      }
      when 'occurrence' {
        // Sort by numberOfAccounts
        records.sort();
        return records;
      }
      when else {
        throw new SortException(
          'Sorting by: ' +
          orderBy +
          ' is not supported!'
        );
      }
    }
  }

  public class SortException extends Exception {
  }

  public class Record implements Comparable {
    @AuraEnabled
    public String cid;
    @AuraEnabled
    public String contactName;
    @AuraEnabled
    public String accountName;
    @AuraEnabled
    public Integer nbrOfAccounts;

    public Record(
      String contactName,
      String accountName,
      Id contactId,
      Id accountId
    ) {
      this.cid = contactId + '-' + accountId;
      this.contactName = contactName;
      this.accountName = accountName;
      this.nbrOfAccounts = 1;
    }

    public void incrementNbrOfAccounts() {
      this.nbrOfAccounts++;
    }

    public Integer compareTo(Object compareTo) {
      if (this.nbrOfAccounts > ((Record) compareTo).nbrOfAccounts) {
        return -1;
      } else if (this.nbrOfAccounts < ((Record) compareTo).nbrOfAccounts) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
