import { LightningElement, api } from 'lwc';

/**************************************************************************************************************
* @author		Fota Maria-Madalina
* @date			2023-03-03=4
* @description  This class contains all client side logic for the BrtxGenericError Lightning Web Component
**************************************************************************************************************/
export default class BrtxGenericError extends LightningElement {
    @api errorMessage;
}