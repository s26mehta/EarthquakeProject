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

    // define gradients for each heatmap
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
    var red = [ 'rgba(255, 0, 0, 0)'].concat(Array(9).fill('rgba(255, 0, 0, 1)'))
    var yellow = [ 'rgba(255, 221, 56, 0)'].concat(Array(9).fill('rgba(255, 221, 56, 1)'))
    var orange = ['rgba(255, 138, 26, 0)'].concat(Array(9).fill('rgba(255, 138, 26, 1)'))
    var blue = ['rgba(255, 138, 26, 0)'].concat(Array(9).fill('rgba(52, 85, 224, 1)'))

    safeheatmap.set('gradient', safeGradient);
    Medical_heatmap.set('gradient', orange);
    Fire_heatmap.set('gradient', yellow);
    Police_heatmap.set('gradient', blue);
    // turn on heatMap initially
    getPoints();
    heatMap();

    $.getJSON('/getCells', function(data) {
    for (var j=0; j < data.length; j++) {
        console.log(j.location)
        var marker = new google.maps.Marker({
          position: data[j].location,
          map: map,
          icon: {
            path: "M288,144.125 C288,117.625 266.5,96.125 240,96.125 C213.5,96.125 192,117.625 192,144.125 C192,164.063 204.25,181.188 221.594,188.438 L112,489.813 C152,466.313 196,454.563 240,454.563 C284,454.563 328,466.313 368,489.813 L258.406,188.438 C275.781,181.188 288,164.063 288,144.125 L288,144.125 Z M240,422.563 C215.375,422.563 190.812,425.876 166.937,432.313 L240,231.438 L313.063,432.313 C289.188,425.875 264.625,422.563 240,422.563 L240,422.563 Z M355.125,57.563 C374,82.688 384,112.563 384,144.125 C384,175.563 374.031,205.438 355.156,230.563 L329.593,211.313 C344.249,191.813 351.999,168.563 351.999,144.125 C351.999,119.562 344.249,96.312 329.561,76.812 L355.125,57.563 L355.125,57.563 Z M480,144.125 C480,196.563 463.406,246.313 432,288.125 L406.437,268.875 C433.625,232.688 448,189.563 448,144.125 C448,98.687 433.656,55.625 406.5,19.375 L432.125,0.187 C463.438,42 480,91.75 480,144.125 L480,144.125 Z M124.844,230.563 C105.969,205.438 96,175.563 96,144.125 C96,112.562 106,82.687 124.875,57.562 L150.438,76.812 C135.75,96.313 128,119.563 128,144.125 C128,168.563 135.75,191.813 150.406,211.313 L124.844,230.563 L124.844,230.563 Z M32,144.125 C32,189.563 46.375,232.688 73.563,268.875 L48,288.125 C16.594,246.312 0,196.562 0,144.125 C0,91.75 16.563,42 47.875,0.188 L73.5,19.375 C46.344,55.625 32,98.688 32,144.125 L32,144.125 Z",
            // size: new google.maps.Size(30, 30),
            scale: 0.05,
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

function heatMap() {
    // put safe and unsafe heatmaps on map
    safeheatmap.setMap(map);
    // remove severity maps from map
    Medical_heatmap.setMap(null);
    Fire_heatmap.setMap(null);
    Police_heatmap.setMap(null);

    // change classes on buttons so that their styles change
    $("#heat-map-btn").addClass("active");
    $("#severity-map-btn").removeClass("active");

    // show the correct legend and other information
    document.getElementById("severity_map_info").style.display = "none";
    document.getElementById("heat_map_info").style.display = "block";
}

function severityMap() {
    // remove save and unsafe heatmaps from the map
    safeheatmap.setMap(null);

    // add severity level maps to the map
    Medical_heatmap.setMap(map);
    Fire_heatmap.setMap(map);
    Police_heatmap.setMap(map);

    // change classes on buttons so that their styles change
    $("#heat-map-btn").removeClass("active");
    $("#severity-map-btn").addClass("active");

    // show the correct legend and other information
    document.getElementById("severity_map_info").style.display = "block";
    document.getElementById("heat_map_info").style.display = "none";

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
    // var xhttp = new XMLHttpRequest();
    // xhttp.onreadystatechange = function() {
    //     if (xhttp.readyState == 4 && xhttp.status == 200) {
    //     document.getElementById("emergencyState").innerHTML = xhttp.responseText;
    //     }
    // };
    // xhttp.open("GET", "isEarthquake", true);
    // xhttp.send();
}