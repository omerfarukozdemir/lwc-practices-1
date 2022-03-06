'use strict';

// To store handles to items in the scope of the page
let _pageConfigs = {};

function setPageConfigs(configs) {
    _pageConfigs = { ...configs };
}

let lwcChannelSubscription;
let auraChannelSubscription;

function handleVFPublishMessage() {
    const payload = {
        param1: "Message Has Been Sent from VFPage",
        param2: "Hello world!"
    };
    _pageConfigs.vfPublish(_pageConfigs.messageChannelVF, payload);
}

function subscribeToLWCMessageChannel(channel, handler) {
    if (!lwcChannelSubscription) {
        lwcChannelSubscription = _pageConfigs.lwcSubscribe(channel, handler);
    }
}

function subscribeToAuraMessageChannel(channel, handler) {
    if (!auraChannelSubscription) {
        auraChannelSubscription = _pageConfigs.auraSubscribe(channel, handler);
    }
}

// Subscribe on page load complete
document.addEventListener('readystatechange', (event) => {
    if (event.target.readyState === 'complete') {
        subscribeToLWCMessageChannel(
            _pageConfigs.messageChannelLWC,
            handleLWCMessageRemoting
        );
        subscribeToAuraMessageChannel(
            _pageConfigs.messageChannelAura,
            handleAuraMessageRemoting
        );

        var button = document.querySelector('button');
        button.addEventListener('click', handleVFPublishMessage);

    }
});

function handleLWCMessageRemoting(message) {
    const { param1, param2 } = message;
    console.log('VF ALERT (message from lwc)');
    console.log(param1 + ' ' + param2);
}

function handleAuraMessageRemoting(message) {
    const { param1, param2 } = message;
    console.log('VF ALERT (message from aura)');
    console.log(param1 + ' ' + param2);
}

// Expose function to pass in page objects
export { setPageConfigs };
