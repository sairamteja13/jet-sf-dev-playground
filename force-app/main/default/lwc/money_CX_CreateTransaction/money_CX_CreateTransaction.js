import { LightningElement } from 'lwc';
import userId from '@salesforce/user/Id';
import AMOUNT_FIELD from '@salesforce/schema/Transaction__c.Transaction_Amount__c';
import DATE_FIELD from '@salesforce/schema/Transaction__c.Transaction_Date__c';
import TYPE_FIELD from '@salesforce/schema/Transaction__c.Type_of_Transaction__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Transaction__c.Description__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Money_CX_CreateTransaction extends LightningElement {
    objectApiName = 'Transaction__c';
    amount = AMOUNT_FIELD;
    date = DATE_FIELD;
    type = TYPE_FIELD;
    description = DESCRIPTION_FIELD;
    userId = userId;

    handleChange(event) {
        const field = event.target.name;
        if (field === 'amount') {
            this.amount = event.target.value;
        } else if (field === 'date') {
            this.date = event.target.value;
        } else if (field === 'type') {
            this.type = event.target.value;
        } else if (field === 'description') {
            this.description = event.target.value;
        }
    }

    handleSubmit(event) {
        const transactionId = event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Transaction created successfully!',
                variant: 'success',
            }),
        );
        event.preventDefault();
    }
}