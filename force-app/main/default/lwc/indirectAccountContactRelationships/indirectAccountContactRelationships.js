import { api, LightningElement } from "lwc";
import getAccountContactRelationships from "@salesforce/apex/AccountContactController.getRecords";

export default class IndirectAccountContactRelationships extends LightningElement {
  @api
  recordId;
  @api
  numberOfItems;
  @api
  sortBy;

  accountContactRelations;

  connectedCallback() {

      getAccountContactRelationships({
        numberOfRecords: this.numberOfItems
      }).then(result => {
        this.accountContactRelations = result;
      }).catch(err => console.error('fucking error', err));

  }

  // async getAccountContactRelationRecords() {
  // }
}
