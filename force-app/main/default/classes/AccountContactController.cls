/**
 * @description       : Apex controller, to manage AccountContact relationships
 * @author            : mostafa.asharf
 * @group             : Apex domain badge
 * @last modified on  : 25-01-2023
 * @last modified by  : mostafa.asharf
 **/
public without sharing class AccountContactController {
  @AuraEnabled
  public static List<Record> getRecords(Integer numberOfRecords) {
    List<AccountContactRelation> accontContactRelations = [
      SELECT Id, ContactId, AccountId, Contact.Name, Account.Name
      FROM AccountContactRelation
      WITH SECURITY_ENFORCED
      LIMIT :numberOfRecords
    ];

    List<Record> records = new List<Record>();

    for (AccountContactRelation relation : accontContactRelations) {
      String cid = relation.ContactId + '-' + relation.AccountId;
      records.add(
        new Record(cid, relation.Contact.Name, relation.Account.Name)
      );
    }
    return records;
  }

  public class Record {
    @AuraEnabled
    public String cid;
    @AuraEnabled
    public String contactName;
    @AuraEnabled
    public String accountName;

    public Record(String cid, String contactName, String accountName) {
      this.cid = cid;
      this.contactName = contactName;
      this.accountName = accountName;
    }
  }
}
