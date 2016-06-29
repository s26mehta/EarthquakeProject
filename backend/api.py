from bottle import *
import logging
import json

app = Bottle()


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
    def __init__(self, _name, _status = 0, _location = None):
        self.name = _name
        self.status = _status
        self.location = _location

    def dump(self):
        if self.location:
            return '{"name":'+str(self.name)+', "status": '+str(self.status)+', "location": '+str(self.location.dump())+'}'
        return '{"name":'+str(self.name)+', "status": '+str(self.status)+'}'


    def isSafe(self):
        if self.status == 1: # 1 is safe
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
        ret = "["
        for i in self.array:
            ret += i.dump() +","
        return ret[:-1] +"]"
 
    def setSafe(self, _name):
        for i in self.array:
            if i.name == _name:
                i.status = 1

    def setNewLocation(self, _name, _loc):
        for i in self.array:
            if i.name == _name:
                i.location = _loc
        
people = People()

@app.route('/')
def home():
    return static_file("index.html", root='.')

@app.get('/isEarthquake')
def get_earthquake_now():
    log.debug("isearthquake: " + str(people.isEarthquake))
    return str(people.isEarthquake)

@app.post('/setEarthquake')
def set_earthquake_now():
    forms = request.forms
    if forms['eq'] == str(1):
        people.isEarthquake = True
    else:
        people.isEarthquake = False
    log.debug(people.isEarthquake)

@app.get('/getSafe')
def getSafePeople():
    return people.whoIsSafe()

@app.get('/getPeople')
def getSafePeople():
    return people.everyone()

@app.post('/newPerson')
def newPerson():
    return people.newPerson(request.forms['name'])

@app.post('/setSafe')
def setSafePerson():
    forms = request.forms
    people.setSafe(forms['name'])

    
@app.post('/newLocation')
def updateLocation():
    forms = request.forms
    people.setNewLocation(forms['name'], Location(forms['lat'], forms['lon']))


class StripPathMiddleware(object):
    '''
    Get that slash out of the request
    '''
    def __init__(self, a):
        self.a = a
    def __call__(self, e, h):
        e['PATH_INFO'] = e['PATH_INFO'].rstrip('/')
        return self.a(e, h)

run(app=StripPathMiddleware(app), host="0.0.0.0", port="1801", reloader=False)