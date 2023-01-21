import { LightningElement, api, wire } from "lwc";
import convertToPDF from "@salesforce/apex/ClientPlanController.convertToPDF";
import { getRecord } from "lightning/uiRecordApi";

const ACCOUNT_FIELDS = ["Account.Id", "Account.Name"];

export default class PrintClientPage extends LightningElement {
  @api recordId;

  @wire(getRecord, { recordId: "$recordId", fields: ACCOUNT_FIELDS })
  account;

  handlePrintClick() {
    console.log("print button click!");
    console.log("account data: ", this.account);
    console.log("account Id: ", this.account.data.fields.Id.value);
    console.log("account data: ", this.account.data.fields.Name.value);
    let accountData = {
      Id: this.account.data.fields.Id.value,
      Name: this.account.data.fields.Name.value
    };
    convertToPDF({ account: accountData })
      .then((result) => {
        console.log("pdf conversion result", result);
      })
      .catch((err) => console.log("Something went wrong!", err));
  }
}
