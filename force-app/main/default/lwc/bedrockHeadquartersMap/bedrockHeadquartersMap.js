import { LightningElement, api } from "lwc";

export default class BedrockHeadquartersMap extends LightningElement {
  mapMarkers = [
    {
      location: {
        Country: "USA",
        State: "CA",
        City: "San Francisco",
        Street: "The Landmark @ One Market, Suite 300",
        PostalCode: "94105"
      },
      title: "bedrock's corporate headquarters",
      description: "The Location of Bedrock's corporate Headquarters",
      icon: "standard:account"
    },
    {
      location: {
        Country: "USA",
        State: "CA",
        City: "San Francisco",
        Street: "1800 Mission St",
        PostalCode: "94103"
      },
      title: "bedrock's corporate headquarters",
      description: "The Location of Bedrock's corporate Headquarters",
      icon: "standard:account",
      type: "Circle",
      radius: 200,
      strokeColor: "red",
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: "red",
      fillOpacity: 1
    }
  ];

  @api
  zoomLevel = 12;
  listViewVisibility = "Hidden";
}
