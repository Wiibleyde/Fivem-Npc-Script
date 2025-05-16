function Delay(ms) {
    return new Promise(response => setTimeout(response, ms));
}

const url = `https://${GetParentResourceName()}/`;
function post(func, data) {
    const stringifiedData = data == null ? '{}' : JSON.stringify(data);
    return fetch(url + func, {method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: stringifiedData}).then(resp => resp);
}

function showInteraction(title, description, image) {
    document.getElementById('interaction-title').innerHTML = title;
    document.getElementById('interaction-desc').innerHTML = description;
    document.getElementById('interaction-image').src = image;
    document.getElementById('interaction-container').style.display = 'block';
}

function closeAllInteraction() {
    document.getElementById('interaction-container').style.display = 'none';
    // Send message to resource that interface was closed
    post('closeInteraction', {});
}

// Initialize close button event listener after DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    const closeButton = document.getElementById('close-button');
    if (closeButton) {
        closeButton.addEventListener('click', function() {
            closeAllInteraction();
        });
    }
});

// NUI Event handler 
window.addEventListener(`message`, async function(e) {
    const request = e.data;
    
    switch (request.action) {
        case 'showInteraction':
            // Extract data directly from request since that's how client.lua sends it
            const { title, description, image } = request;
            // Open the interaction dialog with the provided data
            showInteraction(title, description, image);
            break;
            
        case 'closeAllInteractions':
            // Close all interaction dialogs
            closeAllInteraction();
            break;

        default:
            console.warn('Unknown action received:', request.action);
    }
});