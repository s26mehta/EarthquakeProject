var map, heatmap, currentMap, towers;

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
    var yellow = [ 'rgba(255, 207, 4, 0)'].concat(Array(9).fill('rgba(255, 207, 4, 1)'))
    var orange = ['rgba(255, 138, 26, 0)'].concat(Array(9).fill('rgba(255, 138, 26, 1)'))
    var blue = ['rgba(48, 35, 174, 0)'].concat(Array(9).fill('rgba(48, 35, 174, 1)'))

    safeheatmap.set('gradient', green);
    Medical_heatmap.set('gradient', red);
    Fire_heatmap.set('gradient', orange);
    Police_heatmap.set('gradient', blue);
    // turn on heatMap initially
    getPoints();

    towers = [];
    $.getJSON('/getCells', function(data) {
        for (var j=0; j < data.length; j++) {
            var marker = new google.maps.Marker({
              position: data[j].location,
              map: map,
              icon: {
                        url: '/img/cell icon-20w.png',
                        size: new google.maps.Size(20, 32)
                        // origin: new google.maps.Point(0, 0),
                        // anchor: new google.maps.Point(0, 32)
                      }
            });
            towers.push(marker)
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
    // update checked maps
    if (document.getElementById("medical_check").checked)
        Medical_heatmap.setMap(map);
    else 
        Medical_heatmap.setMap(null);
    if (document.getElementById("fire_check").checked)
        Fire_heatmap.setMap(map);
    else
        Fire_heatmap.setMap(null);
    if (document.getElementById("police_check").checked)
        Police_heatmap.setMap(map);
    else
        Police_heatmap.setMap(null);
    if (document.getElementById("safe_check").checked)
        safeheatmap.setMap(map);
    else
        safeheatmap.setMap(null);
    if (document.getElementById("cell_check").checked){
        for (var j=0; j < towers.length; j++) {
            towers[j].setMap(map);
        }
    }
    else {
        for (var j=0; j < towers.length; j++) {
            towers[j].setMap(null);
        }
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

    var doSomethingAJAX = function (el, url) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onload = function () { el.innerHTML = xhr.responseText; };
        xhr.onerror = function () { /* ... */ };
        xhr.send();
    };

    doSomethingAJAX(document.getElementById("emergencyInfo"), '/getEmergData')
    doSomethingAJAX(document.getElementById("countUnsafe"), '/countUnSafe')
    doSomethingAJAX(document.getElementById("countSafe"), '/countSafe')

}