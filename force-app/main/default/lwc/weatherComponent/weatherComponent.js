import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getResponseFromAPI from '@salesforce/apex/AC_Weather_Component_Ctrl.getResponseFromAPI';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

import ADDRESS_FIELD from '@salesforce/schema/Contact.AC_Address__c';
import ID_FIELD from '@salesforce/schema/Contact.Id';

const fields = [ADDRESS_FIELD];

/*********************************************************************************
* @author         Fota Maria-Madalina
* @date           06-03-2023
* @description    This class contains the client side logic for the weatherComponent Lightning Web Component
**********************************************************************************/
export default class WeatherComponent extends LightningElement {
    @api recordId;
    isLoading = false;
    showError = false;
    weatherData;
    contact;
    address;
    city;
    countryCode;

    @wire(getRecord, { recordId: '$recordId', fields })
    wiredContact({ error, data }) {
        if (data) {
            this.contact = data;
            this.address = this.contact.fields.AC_Address__c.value;
            if(this.address){
                this.city = this.address.split(' ')[0];
                this.countryCode = this.address.split(' ')[1];
                this.getWeatherData(this.city, this.countryCode);
            }else{
                this.showError = true;
                this.errorMessage = 'The address field must be filled in to be able to see the weather.';
            }
        } else if (error) {
            this.showError = true;
            this.errorMessage = error.body.message;
        }
    }


    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This method calls the getResponseFromAPI() method in the apex controller to retrieve the weather data
    **********************************************************************************/
    getWeatherData(city, countryCode) {
        this.isLoading = true;
        getResponseFromAPI({ city: city, countryCode: countryCode }).then(result => {
            if (result) {
                this.weatherData = result;
                for (let i = 0; i < this.weatherData.length; i++) {
                    this.weatherData[i].temperature = parseInt(this.weatherData[i].temperature);
                    this.weatherData[i].temperatureDateTime = this.weatherData[i].temperatureDateTime.split(' ')[1].slice(0, -3);
                    this.weatherData[i].icon = 'http://openweathermap.org/img/wn/' + this.weatherData[i].icon + '@2x.png';
                }
            }
        }).catch(error => {
            this.showError = true;
            this.errorMessage = error.body.message;
        }).finally(_ => {
            this.isLoading = false;
        });
    }

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This method validates and saves the new address on the contact record when "Update Contact Address" is pressed
    **********************************************************************************/
    handleEditButtonClick(event) {
        var cityInputCmp = this.template.querySelector('.city-input');
        var countryInputCmp = this.template.querySelector('.country-input');

        var cityValue = cityInputCmp.value;
        var countryValue = countryInputCmp.value;

        if (cityValue == this.city) {
            cityInputCmp.setCustomValidity('Please change the city.');
        } else {
            cityInputCmp.setCustomValidity('');
        }

        cityInputCmp.reportValidity();

        if (cityInputCmp.checkValidity()) {
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[ADDRESS_FIELD.fieldApiName] = cityValue + ' ' + countryValue;

            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact updated',
                            variant: 'success'
                        })
                    );

                    return refreshApex(this.contact);
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
    }

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    Refreshes the component when the 'Refresh' button is pressed
    **********************************************************************************/
    handleRefreshClick(){
        updateRecord({fields: { Id: this.recordId }});
    }
}