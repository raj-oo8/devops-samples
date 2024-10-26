window.onload = function () {
    // Check if service workers are supported
    if ('serviceWorker' in navigator) {
        // Register the service worker
        navigator.serviceWorker.register('service-worker.js').then(function (registration) {
            // Check if the user is already subscribed
            return registration.pushManager.getSubscription();
        }).then(function (subscription) {
            if (!subscription) {
                // If not subscribed, ask for permission and subscribe
                return subscribeUser();
            }
        });
    }
};

function subscribeUser() {
    navigator.serviceWorker.ready.then(function (registration) {
        return registration.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: 'BARjuYbitkKPPiBfKbofKw1VJx78Z9J_3oNQGeOAU3Yp8SJNJFEgqlCegA1iZjkc67F4SUrZ30uWwxan3y7O5zY'
        });
    }).then(function (subscription) {
        // Send the subscription object to your server to register the subscription
        console.log('Subscribed', subscription);
    }).catch(function (error) {
        console.error('Failed to subscribe', error);
    });
}
