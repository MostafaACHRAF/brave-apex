public with sharing class ClientPlanController {
  public String accountId { get; set; }
  public String accountName { get; set; }

  @AuraEnabled
  public static void convertToPDF(Account account) {
    PageReference pdfFile = new PageReference(
      '/apex/ClientPlan?aId=' + account.Id
    );
    Blob body;

    try {
      body = pdfFile.getContentAsPDF();
    } catch (VisualforceException e) {
      System.debug('Failed to convert file to PDF! ' + e);
    }

    String pdfTitle =
      account.Name +
      'ClientPlan' +
      Date.today() +
      '-' +
      (Math.round(Math.random() * 9 + 10));
    ContentVersion pdfConventVersion = new ContentVersion();
    pdfConventVersion.VersionData = body;
    pdfConventVersion.Title = pdfTitle;
    pdfConventVersion.PathOnClient = pdfTitle + '.pdf';
    pdfConventVersion.IsMajorVersion = false;

    insert pdfConventVersion;

    ContentDocument myDocument = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
      WHERE Title = :pdfTitle
    ];

    ContentDocumentLink contentlink = new ContentDocumentLink(
      ShareType = 'V',
      LinkedEntityId = account.Id,
      ContentDocumentId = myDocument.Id
    );

    insert contentlink;

    System.debug('contentVersion ' + pdfConventVersion);
    System.debug('contentDocument ' + myDocument);
    System.debug('contentLink ' + contentlink);
  }

  public PageReference init() {
    this.accountId = String.escapeSingleQuotes(
        ApexPages.currentPage()?.getParameters().get('aId')
      )
      .trim();
    this.accountName = 'Denji Name';
    return null;
  }
}
