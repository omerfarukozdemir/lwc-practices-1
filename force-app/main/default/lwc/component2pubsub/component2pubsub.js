import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent, registerListener, unregisterAllListeners } from 'c/pubsub';

export default class Component2pubsub extends LightningElement {
    @wire(CurrentPageReference) pageRef;

    handleFireEvent() {
        let params = {
            'param1': 'this is the first param from comp2',
            'param2' : 'this is the second param from comp2'
        };
        fireEvent(this.pageRef, 'comp2tocomp1' , params);
    }

    connectedCallback() {
        registerListener('comp1tocomp2', this.handleMessage, this);
    }

    handleMessage(data) {
        alert('alert from comp2: ' + JSON.stringify(data));
    }
    
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
}