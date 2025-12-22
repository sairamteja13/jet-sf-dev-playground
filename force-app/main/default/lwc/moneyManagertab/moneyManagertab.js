import { LightningElement } from 'lwc';
import { track,wire,api } from 'lwc';

const tabValues = ['All Time','Yearly','Monthly'];

export default class MoneyManagertab extends LightningElement {

    @track activeTabValue = tabValues[0];

    get tabs() {
        const tabs = [];
        for (let i = 0; i < tabValues.length; i++) {
            tabs.push({
                value: tabValues[i],
                label: tabValues[i],
            });
        }
        return tabs;
    }

    handleActiveTab(event) {
        this.activeTabValue = event.target.value;
    }


}