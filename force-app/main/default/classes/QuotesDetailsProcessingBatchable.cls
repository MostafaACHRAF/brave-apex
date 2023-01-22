/**
 * @description       : Batchable Apex class, that processes staging Quote records,
 * and transform them into QuoteLineItem records
 * and associate QuoteLineItem records with the corresponding Quote records
 * @author            : mostafa.asharf
 * @group             : Apex domain badge
 * @last modified on  : 22-01-2023
 * @last modified by  : mostafa.asharf
 **/
public with sharing class QuotesDetailsProcessingBatchable {
  private final Map<Id, Quote> staginQuoteToQuote;

  /**
   * @description Batchable constructor
   * @author mostafa.asharf | 22-01-2023
   * @param Map<Id Quote> staginQuoteToQuote
   **/
  public QuotesDetailsProcessingBatchable(Map<Id, Quote> staginQuoteToQuote) {
    this.staginQuoteToQuote = staginQuoteToQuote;
  }

  /**
   * @description Batchable start method
   * We will process the details records where they are associated with one of the given staging quote records
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   * @return Database.QueryLocator
   **/
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      [
        SELECT Id
        FROM Healthcare_QuoteDetail_Staging__c
        WHERE Quote_Staging__c IN :staginQuoteToQuote.keySet()
      ]
    );
  }

  /**
   * @description Batchable execute method.
   * Transoform staging quote detials to standard QuoteLineItem records
   * Associate each record with its corresponding Quote record
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   * @param List<SObject> staginQuoteDetails
   **/
  public void execute(
    Database.BatchableContext bc,
    List<SObject> staginQuoteDetails
  ) {
    List<QuoteLineItem> standardQuoteDetails = new List<QuoteLineItem>();

    for (SObject stagingQuoteDetail : staginQuoteDetails) {
      QuoteLineItem quoteDetail = new QuoteLineItem();
      // populate QuoteLineItem from stagingQuoteDetails
      // quoteDetail.quoteId = stagingQuoteToQuote.get(stagingQuoteDetail.StagingQuote__c)?.Id;
      standardQuoteDetails.add(quoteDetail);
    }
    upsert staginQuoteDetails;
  }

  /**
   * @description Batchable finish method
   * @author mostafa.asharf | 22-01-2023
   * @param Database.BatchableContext bc
   * @param List<SObject> staginQuoteDetails
   **/
  public void finish(Database.BatchableContext bc) {
    // send an email notification
  }
}
