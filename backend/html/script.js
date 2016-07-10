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
    unsafeheatmap = new google.maps.visualization.HeatmapLayer({
        map: map
    });
    safeheatmap = new google.maps.visualization.HeatmapLayer({
        map: map
    });
    L1_heatmap = new google.maps.visualization.HeatmapLayer({
        map: null
    });
    L2_heatmap = new google.maps.visualization.HeatmapLayer({
        map: null
    });
    L3_heatmap = new google.maps.visualization.HeatmapLayer({
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
    var red = [
    'rgba(255, 0, 0, 0)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)',
    'rgba(255, 0, 0, 1)'
    ]
    var yellow = [
    'rgba(255, 221, 56, 0)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)',
    'rgba(255, 221, 56, 1)'
    ]
    var orange = [
    'rgba(255, 138, 26, 0)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)',
    'rgba(255, 138, 26, 1)'
    ]

    safeheatmap.set('gradient', safeGradient);
    unsafeheatmap.set('gradient', unSafeGradient);
    L1_heatmap.set('gradient', yellow);
    L2_heatmap.set('gradient', orange);
    L3_heatmap.set('gradient', red);
    // turn on heatMap initially
    getPoints();
    heatMap();

    // get new data from server every 3s
    window.setInterval(function() {
        getPoints();
        getStatus();
    }, 3000);
}

function heatMap() {
    // put safe and unsafe heatmaps on map
    safeheatmap.setMap(map);
    unsafeheatmap.setMap(map);
    // remove severity maps from map
    L1_heatmap.setMap(null);
    L2_heatmap.setMap(null);
    L3_heatmap.setMap(null);

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
    unsafeheatmap.setMap(null);

    // add severity level maps to the map
    L1_heatmap.setMap(map);
    L2_heatmap.setMap(map);
    L3_heatmap.setMap(map);

    // change classes on buttons so that their styles change
    $("#heat-map-btn").removeClass("active");
    $("#severity-map-btn").addClass("active");

    // show the correct legend and other information
    document.getElementById("severity_map_info").style.display = "block";
    document.getElementById("heat_map_info").style.display = "none";

}

function getPoints() {
    var safe_arr = [];
    var unsafe_arr = [];
    var L1_arr = [];
    var L2_arr = [];
    var L3_arr = [];
    $.getJSON('/getPeople', function(data) {

        people = data
        for (var j=0; j < people.length; j++) {
            // loop through each person in the json data

            if (people[j].location){
                var a = new google.maps.LatLng(people[j].location.lat, people[j].location.lon);
                // create new maps point for this person

                if (people[j].status == "unsafe"){
                    // if the person is unsafe, add them to the unsafe map
                    unsafe_arr.push(a);
                    // add the person to the appropriate level of severity on the severity map
                    if (people[j].severity == "L1"){
                        L1_arr.push(a);
                    }
                    else if (people[j].severity == "L2"){
                        L2_arr.push(a);
                    }
                    else if (people[j].severity == "L3"){
                        L3_arr.push(a);
                    }
                }
                else if (people[j].status == "safe"){
                    // if the person is safe, add them to the safe map
                    safe_arr.push(a);
                }
            }

        }

        // add all ponts to approprate arrays
        unsafeheatmap.set('data', new google.maps.MVCArray(unsafe_arr));
        safeheatmap.set('data', new google.maps.MVCArray(safe_arr));

        L1_heatmap.set('data', new google.maps.MVCArray(L1_arr));
        L2_heatmap.set('data', new google.maps.MVCArray(L2_arr));
        L3_heatmap.set('data', new google.maps.MVCArray(L3_arr));
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