const data = []

document.addEventListener("DOMContentLoaded", function () {
    const messagesDiv = document.getElementById("messages");
    const socket = new WebSocket("ws://localhost:51282");

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
        data.push(message);
        drawParkingLot(message);
    }
});


function drawParkingLot(message) {
    const jsonData = JSON.parse(message);
    const spaceData = jsonData["parking_space"];

    const parkingLot = document.createElement('div');
    parkingLot.classList.add('parking-lot');

    for (const level of spaceData) {
        parkingLot.appendChild(makeLevel(level));
    }

    document.body.appendChild(parkingLot);
    document.body.appendChild(document.createElement('br'));

}

function makePlace(data) {
    const place = document.createElement('div');
    place.classList.add('place');
    debugger;
    if (!data) {
        place.classList.add('free');
        return place;
    }

    if (data.startsWith("auto")) {
        place.classList.add('auto');
    } else if (data.startsWith("bus")) {
        place.classList.add('bus');
    } else if (data.startsWith("moto")) {
        place.classList.add('moto');
    } else {
        place.classList.add('free');
    }

    return place;
}

function makeRow(data) {
    const row = document.createElement('div');
    row.classList.add('row');

    for (const place of data) {
        const p = makePlace(place);
        row.appendChild(p);
    }

    return row;
}

function makeLevel(data) {
    const level = document.createElement('div');
    level.classList.add('level');

    for (const row of data) {
        const r = makeRow(row);
        level.appendChild(r);
    }

    return level;
}