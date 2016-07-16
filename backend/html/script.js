var map, heatmap, currentMap;

function initMap() {
    // create map options
    var mapOptions = {
        zoom: 13,
        center: {lat: 43.460474, lng: -80.504281},
        styles: [{"featureType":"administrative.province","elementType":"labels.text.fill","stylers":[{"color":"#434242"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#434242"}]},{"featureType":"administrative.neighborhood","elementType":"labels.text.fill","stylers":[{"color":"#434242"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"transit.line","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"hue":"#0073ff"}]}]
    }
    //make map and link to map div
    map = new google.maps.Map(document.getElementById('map'), mapOptions);

    // make layers for each heatmap
    safeheatmap = new google.maps.visualization.HeatmapLayer({
        map: map
    });
    Medical_heatmap = new google.maps.visualization.HeatmapLayer({
        map: null
    });

    Police_heatmap = new google.maps.visualization.HeatmapLayer({
        map: null
    });
    Fire_heatmap = new google.maps.visualization.HeatmapLayer({
        map: null
    });

    // define gradients for eaB4EC51ch heatmap
    var safeGradient = [
        'rgba(0, 255, 255, 0)',
        'rgba(0, 255, 255, 1)',
        'rgba(0, 191, 255, 1)',
        'rgba(0, 127, 255, 1)',
        'rgba(0, 63, 255, 1)',
        'rgba(0, 0, 255, 1)',
        'rgba(0, 0, 223, 1)',
        'rgba(0, 0, 191, 1)',
        'rgba(0, 0, 159, 1)',
        'rgba(0, 0, 127, 1)',
        'rgba(63, 0, 91, 1)',
        'rgba(127, 0, 63, 1)',
        'rgba(191, 0, 31, 1)',
        'rgba(255, 0, 0, 1)'
        ]
    var unSafeGradient = [
        'rgba(255, 255, 0, 0)',
        'rgba(255, 255, 0, 1)',
        'rgba(255, 225, 0, 1)',
        'rgba(255, 200, 0, 1)',
        'rgba(255, 175, 0, 1)',
        'rgba(255, 160, 0, 1)',
        'rgba(255, 145, 0, 1)',
        'rgba(255, 125, 0, 1)',
        'rgba(255, 110, 0, 1)',
        'rgba(255, 100, 0, 1)',
        'rgba(255, 75, 0, 1)',
        'rgba(255, 50, 0, 1)',
        'rgba(255, 25, 0, 1)',
        'rgba(255, 0, 0, 1)'
        ]
    // var red = 'rgba(255, 0, 0, 0)';
    var green = [ 'rgba(66, 147, 33, 0)'].concat(Array(9).fill('rgba(66, 147, 33, 1)'))
    var red = [ 'rgba(255, 0, 0, 0)'].concat(Array(9).fill('rgba(255, 0, 0, 1)'))
    var yellow = [ 'rgba(255, 221, 56, 0)'].concat(Array(9).fill('rgba(255, 221, 56, 1)'))
    var orange = ['rgba(255, 138, 26, 0)'].concat(Array(9).fill('rgba(255, 138, 26, 1)'))
    var blue = ['rgba(48, 35, 174, 0)'].concat(Array(9).fill('rgba(48, 35, 174, 1)'))

    safeheatmap.set('gradient', green);
    Medical_heatmap.set('gradient', orange);
    Fire_heatmap.set('gradient', yellow);
    Police_heatmap.set('gradient', blue);
    // turn on heatMap initially
    getPoints();

    $.getJSON('/getCells', function(data) {
    for (var j=0; j < data.length; j++) {
        console.log(j.name)
        console.log(j.location)
        var marker = new google.maps.Marker({
          position: data[j].location,
          map: map,
          icon: {
            path: "M28.77,29.669 C28.759,29.629 28.739,29.594 28.726,29.555 C28.725,29.551 28.723,29.547 28.721,29.542 C28.58,29.132 28.332,28.788 28.012,28.534 C27.998,28.523 27.983,28.514 27.968,28.503 C27.871,28.43 27.769,28.363 27.661,28.306 C27.632,28.291 27.6,28.279 27.569,28.265 C27.47,28.219 27.369,28.178 27.263,28.147 C27.249,28.143 27.237,28.136 27.223,28.132 C27.19,28.123 27.158,28.123 27.125,28.115 C27.034,28.095 26.943,28.077 26.849,28.068 C26.78,28.061 26.712,28.061 26.643,28.061 C26.574,28.061 26.507,28.061 26.438,28.068 C26.344,28.077 26.253,28.094 26.162,28.115 C26.129,28.122 26.097,28.123 26.064,28.132 C26.05,28.136 26.038,28.143 26.024,28.147 C25.918,28.178 25.817,28.219 25.718,28.265 C25.688,28.279 25.656,28.291 25.627,28.306 C25.519,28.362 25.418,28.429 25.321,28.502 C25.307,28.513 25.291,28.522 25.277,28.533 C24.957,28.786 24.71,29.13 24.569,29.54 C24.567,29.545 24.565,29.549 24.564,29.554 C24.551,29.593 24.531,29.627 24.52,29.667 C24.512,29.694 15.271,63.373 15.273,63.373 C15.027,64.506 15.704,65.646 16.835,65.958 C17.966,66.27 19.132,65.637 19.501,64.538 C19.501,64.538 20.607,60.517 22.053,55.253 C25.969,58.571 34.23,65.571 34.23,65.57 C34.689,65.93 35.252,66.079 35.797,66.027 C36.014,66.034 36.233,66.019 36.453,65.959 C37.584,65.647 38.261,64.507 38.016,63.374 C38.019,63.375 28.777,29.696 28.77,29.669 L28.77,29.669 Z M26.645,38.538 C27.17,40.451 27.758,42.588 28.364,44.796 C27.292,45.352 25.752,46.15 24.356,46.873 C25.161,43.943 25.956,41.048 26.645,38.538 L26.645,38.538 Z M29.555,49.131 C30.417,52.268 31.259,55.333 31.963,57.896 C29.385,55.709 26.44,53.211 24.634,51.679 C26.365,50.782 28.186,49.839 29.555,49.131 L29.555,49.131 Z",
            // size: new google.maps.Size(30, 30),
            scale: 0.5,
            fillColor: "#F00",
            fillOpacity: 1,
            strokeWeight: 0
            }
        });
        // marker.setIcon('/img/cell.png')
    }
    });

    // get new data from server every 3s
    window.setInterval(function() {
        getPoints();
        getStatus();
    }, 3000);
}


function updateChecks() {
    console.log(document.getElementById("medical_check").checked)
    // remove save and unsafe heatmaps from the map
    safeheatmap.setMap(null);
    Medical_heatmap.setMap(null);
    Fire_heatmap.setMap(null);
    Police_heatmap.setMap(null);
    // add severity level maps to the map
    
    if (document.getElementById("medical_check").checked){
        Medical_heatmap.setMap(map);
    }
    if (document.getElementById("fire_check").checked){
        Fire_heatmap.setMap(map);
    }
    if (document.getElementById("police_check").checked){
        Police_heatmap.setMap(map);
    }
    if (document.getElementById("safe_check").checked){
        safeheatmap.setMap(map);
    }

}

function getPoints() {
    var safe_arr = [];
    var Medical_arr = [];
    var Fire_arr = [];
    var Police_arr = [];
    $.getJSON('/getPeople', function(data) {
        people = data
        for (var j=0; j < people.length; j++) {
            // loop through each person in the json data
            console.log(people[j].name)
            if (people[j].location){
                var a = new google.maps.LatLng(people[j].location.lat, people[j].location.lon);
                // create new maps point for this person
                console.log(people[j].status)

                if (people[j].status == 0){
                    // person is safe
                    safe_arr.push(a);
                }
                else {
                    // police are needed
                    if ((people[j].status)%10 == 1)
                        Police_arr.push(a);
                    // fire are needed
                    if ((people[j].status/10)%10 == 1)
                        Fire_arr.push(a);
                    // medical are needed
                    if ((people[j].status/100)%10 == 1)
                        Medical_arr.push(a);
                }
            }

        }

        // add all ponts to approprate arrays
        safeheatmap.set('data', new google.maps.MVCArray(safe_arr));
        Medical_heatmap.set('data', new google.maps.MVCArray(Medical_arr));
        Fire_heatmap.set('data', new google.maps.MVCArray(Fire_arr));
        Police_heatmap.set('data', new google.maps.MVCArray(Police_arr));
    });
}

function getStatus(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
        document.getElementById("emergencyState").innerHTML = xhttp.responseText;
        }
    };
    xhttp.open("GET", "getEmergData", true);
    xhttp.send();
}