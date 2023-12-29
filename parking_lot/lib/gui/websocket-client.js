document.addEventListener("DOMContentLoaded", function () {
    const messagesDiv = document.getElementById("messages");
    const socket = new WebSocket("wss://localhost:51210");

    // Connection opened
    socket.addEventListener("open", function (event) {
        console.log("WebSocket connection opened");
        sendMessage("Hello, WebSocket!");
    });

    // Listen for messages
    socket.addEventListener("message", function (event) {
        console.log("Message from server:", event.data);
        displayMessage(event.data);
    });

    // Connection closed
    socket.addEventListener("close", function (event) {
        console.log("WebSocket connection closed");
    });

    // Connection error
    socket.addEventListener("error", function (event) {
        console.error("WebSocket error:", event);
    });

    // Function to send a message
    function sendMessage(message) {
        socket.send(message);
    }

    // Function to display a message on the webpage
    function displayMessage(message) {
        const messageElement = document.createElement("p");
        messageElement.textContent = message;
        messagesDiv.appendChild(messageElement);
    }
});
