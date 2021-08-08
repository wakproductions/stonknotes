import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['closeButton', 'validationErrorAlert'];

  initialize() {
    // console.log('Modal Controller Initialized');
  }

  connect() {
    // console.log('Modal Controller Connected');
    if(!this.hasValidationErrorAlertTarget) this.closeButtonTarget.click();
  }

}