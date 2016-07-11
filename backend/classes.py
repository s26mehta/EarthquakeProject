from datetime import datetime
import json
import logging

logging.basicConfig(filename='log.log', format='%(asctime)s-%(name)s\t-%(levelname)s\t-%(message)s',level=logging.DEBUG)
log = logging.getLogger('log')

class Location():
    """geo location"""
    def __init__(self, _lat = None, _lon = None):
        self.lat = _lat
        self.lon = _lon

    def dump(self):
        return '{"lat": ' + str(self.lat) + ', "lon": ' + str(self.lon) +'}'

class Person():
    """docstring for Person"""
    def __init__(self, _name, _status = "unreported", _severity= "L0", _last_seen = None, _location = None):
        self.name = _name
        self.status = _status
        self.severity = _severity
        self.location = _location
        if type(_location) == dict:
            self.location = Location(_location['lat'], _location['lon'])
        self.last_seen = _last_seen

    def dump(self):
        time = 'null'
        if self.last_seen != None:
            time = int(self.last_seen.strftime("%s"))
        if self.location:
            return '{"name": "'+str(self.name)+'", "status": "'+str(self.status)+'","severity": "'+str(self.severity)+'", "location": '+str(self.location.dump())+', "last_seen": '+str(time)+'}'
        return '{"name":"'+str(self.name)+'", "status": "'+str(self.status)+'","severity": "'+str(self.severity)+'", "last_seen": '+str(time)+'}'

    def isSafe(self):
        if self.status == "safe": # 1 is safe
            return True
        return False

    def updateLocation(self, _loc):
        self.location = _loc

class People():
    """Object for all people in the database"""
    def __init__(self, _array = []):
        self.array = _array
        self.isEarthquake = False

    def newPerson(self, _name):
        self.array.append(Person(_name))

    def whoIsSafe(self):
        isSafe = []
        for i in self.array:
            if i.isSafe():
                isSafe.append(i)
        ret = ""
        for i in isSafe:
            ret += i.dump()
        return ret

    def everyone(self):
        if self.array:
            ret = "["
            for i in self.array:
                ret += i.dump() +","
            return ret[:-1] +"]"
        return '[]'
 
    def setSafe(self, _name, _time=datetime.now()):
        for i in self.array:
            if i.name == _name:
                i.status = "safe"
                i.last_seen = _time

    def setUnSafe(self, _name, _severity, _time=datetime.now()):
        for i in self.array:
            if i.name == _name:
                i.status = "unsafe"
                i.severity = _severity
                i.last_seen = _time

    def setNewLocation(self, _name, _loc, _time=datetime.now()):
        for i in self.array:
            if i.name == _name:
                i.location = _loc
                i.last_seen = _time


    def writeToFile(self):
        with open("people.json", 'w') as outfile:
            outfile.write(self.everyone())

    def readFromFile(self):
        try:
            with open('people.json', 'r') as infile:
                everyone = json.loads(infile.read())
                for i in everyone:
                    time = None
                    if i["last_seen"] != None:
                        datetime.fromtimestamp(int(i['last_seen']))
                    self.array.append(Person(i['name'], i['status'], i['severity'], time, i['location']))
        except Exception, e:
            log.error("Error reading file: " + e.message)