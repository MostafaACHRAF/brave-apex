/**
 * @description       : Batchable Apex class, that processes big chuncks of records,
 * to transform them from {Staging Quotes} => {Standard Quotes},
 * and associate them with customers Accounts
 * @author            : mostafa.asharf
 * @group             : Apex domain badge
 * @last modified on  : 21-01-2023
 * @last modified by  : mostafa.asharf
 **/
public with sharing class QuotesProcessingBatchable implements Database.Batchable<SObject> {
  //   private final List<Id> stagingQuotesIds; // might be used if we use a trigger based solution!
  private final Database.QueryLocator stagingQuotesQL;
  private final Map<Id, Id> stagingQuoteIdToAccountId;
  private final Map<Id, Quote> stagingQuoteIdToQuote;

  /**
   * @description Batchable constructor
   * @author mostafa.asharf | 22-01-2023
   **/
  public QuotesProcessingBatchable() {
    this.stagingQuoteIdToQuote = new Map<Id, Quote>();
    this.stagingQuotesQL = Database.getQueryLocator(
      [SELECT Id FROM Healthcare_Quote_Staging__c]
    );
    this.stagingQuoteIdToAccountId = getstagingQuoteIdToAccountId(
      this.stagingQuotesQL
    );
  }

  /**
   * @description Batchable start method, we will process all staging Quote records
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   * @return Database.QueryLocator
   **/
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return this.stagingQuotesQL;
  }

  /**
   * @description  The execute method of the batchable
   * Transoform each staging Quote into a standard Quote
   * and map each stagin Qutoe with its standard one
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   * @param List<SObject> stagingQuotes
   **/
  public void execute(
    Database.BatchableContext bc,
    List<SObject> stagingQuotes
  ) {
    List<Quote> standardQuotes = new List<Quote>();

    for (SObject stagingQuote : stagingQuotes) {
      Quote standardQuote = transformToStandardQuote(stagingQuote);
      standardQuotes.add(standardQuote);
      this.stagingQuoteIdToQuote.put(stagingQuote.Id, standardQuote);
    }
    upsert standardQuotes; //limitation? => 10000 records per transaction
  }

  /**
   * @description Batchable finish method
   * At finish, start QuotesDetailsProcessingBatchable
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   **/
  public void finish(Database.BatchableContext bc) {
    // start another batchable
    new QuotesDetailsProcessingBatchable(this.stagingQuoteIdToQuote);
  }

  /**
   * @description For each Staging Quote find the associated Account's Id and store it in a map
   * @author mostafa.asharf | 22-01-2023
   * @param List<SObject> stagingQuotes
   * @return Map<Id, Id>
   **/
  private Map<Id, Id> getstagingQuoteIdToAccountId(
    Database.QueryLocator stagingQuotesQL
  ) {
    // Query all Account records associated to the given staging Quotes
    // build and retrn a map where the {key} is the staging Quote's Id, and the {value} is the associated Account's Id

    // Note: use Database.QueryLocator and Database.QueryLocatorIterator
    return new Map<Id, Id>();
  }

  /**
   * @description Transform Staging Quote record to a standard Quote record
   * @author mostafa.asharf | 22-01-2023
   * @param SObject stagingQuote
   * @return Quote
   **/
  private Quote transformToStandardQuote(SObject stagingQuote) {
    //populate the quote's fields from stagingQuote
    //populate the quote's accountId: quote.AccountId = this.stagingQuoteIdToAccountId.get(stagingQuote.Id)?.Id;
    return new Quote();
  }
}
