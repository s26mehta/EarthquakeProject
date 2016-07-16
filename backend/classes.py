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
    def __init__(self, _name, _status = 0, _last_seen = None, _location = None):
        self.name = _name
        self.status = _status
        self.location = _location
        if type(_location) == dict:
            self.location = Location(_location['lat'], _location['lon'])
        self.last_seen = _last_seen

    def dump(self):
        time = 'null'
        if self.last_seen != None:
            time = int(self.last_seen.strftime("%s"))
        if self.location:
            return '{"name": "'+str(self.name)+'", "status": '+str(self.status)+', "location": '+str(self.location.dump())+', "last_seen": '+str(time)+'}'
        return '{"name":"'+str(self.name)+'", "status": '+str(self.status)+', "location": null, "last_seen": '+str(time)+'}'

    def isSafe(self):
        if self.status == 000: # 000 is safe
            return True
        return False

    def updateLocation(self, _loc):
        self.location = _loc

class People():
    """Object for all people in the database"""
    def __init__(self, _array = []):
        self.array = _array
        self.isEmergency = False
        self.region = "null"
        self.emergencyType = "null"
    def countSafe(self):
        j = 0
        for i in self.array:
            if i.isSafe():
                j+=1
        return j

    def countUnsafe(self):
        j = 0
        for i in self.array:
            if not i.isSafe():
                j+=1
        return j

    def newPerson(self, _name):
        if not self.isInList(_name):
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
 
    def setStatus(self, _name, _status, _time=datetime.now()):
        for i in self.array:
            if i.name == _name:
                i.status = _status
                i.last_seen = _time

    def setNewLocation(self, _name, _loc, _time=datetime.now()):
        for i in self.array:
            if i.name == _name:
                i.location = _loc
                i.last_seen = _time

    def isInList(self, _name):
        for i in self.array:
            if i.name == _name:
                return True
        return False

    def writeToFile(self):
        with open("people.json", 'w') as outfile:
            if self.isEmergency:
                outfile.write('{"isEmergency": ' + str(self.isEmergency).lower() + ', "region": "' + str(self.region) + '", "emergencyType": "' + self.emergencyType + '", "everyone": ')
            else:
                outfile.write('{"isEmergency": ' + str(self.isEmergency).lower() + ', "everyone": ')
            outfile.write(self.everyone())
            outfile.write('}')

    def readFromFile(self):
        try:
            with open('people.json', 'r') as infile:
                data = json.loads(infile.read())
                self.isEmergency = bool(data['isEmergency'])
                if self.isEmergency:
                    self.region = data['region']
                    self.emergencyType = data['emergencyType']

                everyone = data['everyone']
                for i in everyone:
                    time = None
                    log.debug(i['name'])
                    if i["last_seen"] != None:
                        time = datetime.fromtimestamp(int(i['last_seen']))
                    loc = None
                    if i['location'] != None:
                        loc=i['location']
                    self.array.append(Person(i['name'], _status=i['status'], _last_seen=time, _location=loc))
        except Exception, e:
            log.error("Error reading file: " + e.message)