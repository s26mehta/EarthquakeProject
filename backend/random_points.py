import requests
import random

# send random points to the server

def pushRand(lowName, highName, centerLat, centerLon, gaussSigma, statuses):
    for i in range(lowName,highName):
        lat = random.gauss(centerLat, gaussSigma)
        lon = random.gauss(centerLon, gaussSigma)
        requests.post("http://localhost:1801/setStatus", data={"name" : i, "time": 100, "status": random.choice(statuses), "lat": lat, "lon": lon})

for i in range(0,130):
    requests.post("http://localhost:1801/newPerson", data={"name" : i})


pushRand(13, 30, 43.469179, -80.575330, 0.002, [100,10]);
pushRand(31, 60, 43.454179, -80.570330, 0.002, [10,1]);
pushRand(61, 70, 43.458179, -80.530330, 0.0007, [100]);
pushRand(81, 90, 43.449179, -80.500330, 0.01, [100]);
pushRand(91, 100, 43.469179, -80.500330, 0.005, [0]);
pushRand(101, 110, 43.469179, -80.500330, 0.01, [0]);
pushRand(111, 120, 43.450179, -80.570330, 0.01, [0]);
pushRand(121, 130, 43.455179, -80.540330, 0.01, [0]);

