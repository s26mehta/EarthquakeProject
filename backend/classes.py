class Location():
    """geo location"""
    def __init__(self, _lat = None, _lon = None):
        self.lat = _lat
        self.lon = _lon

    def dump(self):
        return '{"lat": ' + str(self.lat) + ', "lon": ' + str(self.lon) +'}'

class Person():
    """docstring for Person"""
    def __init__(self, _name, _status = "unreported", _severity= "L0", _location = None):
        self.name = _name
        self.status = _status
        self.severity = _severity
        self.location = _location

    def dump(self):
        if self.location:
            return '{"name": "'+str(self.name)+'", "status": "'+str(self.status)+'","severity": "'+str(self.severity)+'", "location": '+str(self.location.dump())+'}'
        return '{"name":"'+str(self.name)+'", "status": "'+str(self.status)+'","severity": "'+str(self.severity)+'"}'

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
 
    def setSafe(self, _name):
        for i in self.array:
            if i.name == _name:
                i.status = "safe"

    def setUnSafe(self, _name, _severity):
        for i in self.array:
            if i.name == _name:
                i.status = "unsafe"
                i.severity = _severity

    def setNewLocation(self, _name, _loc):
        for i in self.array:
            if i.name == _name:
                i.location = _loc