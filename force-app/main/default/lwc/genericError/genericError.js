import { LightningElement, api } from 'lwc';

/**************************************************************************************************************
* @author		Fota Maria-Madalina
* @date			06-03-2023
* @description  This class contains all client side logic for the genericError Lightning Web Component
**************************************************************************************************************/
export default class BrtxGenericError extends LightningElement {
    @api errorMessage;
}