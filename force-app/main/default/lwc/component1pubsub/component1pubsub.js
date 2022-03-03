import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent, registerListener, unregisterAllListeners } from 'c/pubsub';

export default class Component1pubsub extends LightningElement {
    @wire(CurrentPageReference) pageRef;

    handleFireEvent() {
        let params = {
            'param1': 'this is the first param from comp1',
            'param2' : 'this is the second param from comp1'
        };
        fireEvent(this.pageRef, 'comp1tocomp2' , params);
    }

    connectedCallback() {
        registerListener('comp2tocomp1', this.handleMessage, this);
    }

    handleMessage(data) {
        alert('alert from comp1: ' + JSON.stringify(data));
    }
    
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
}