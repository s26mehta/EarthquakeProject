from bottle import *
import logging

app = Bottle()


logging.basicConfig(filename='log.log', format='%(asctime)s-%(name)s\t-%(levelname)s\t-%(message)s',level=logging.DEBUG)
log = logging.getLogger('log')

class Location():
    """geo location"""
    def __init__(self, _lat = None, _lon = None):
        super(location, self).__init__()
        self.lat = _lat
        self.lon = _lon

class Person():
    """docstring for Person"""
    def __init__(self, _name, _status, _location = None):
        self.name = _name
        self.status = _status
        self.location = _location

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

    def newPerson(self, _name, _status):
        self.array.append(Person(_name, _status))

    def whoIsSafe(self):
        isSafe = []
        for i in self.array:
            if i.isSafe():
                isSafe.append(i)
        return isSafe

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

@app.post('/newPerson')
def newPerson():
    return people.new(request.forms['name'])

@app.post('/setSafe')
def setSafePerson(self):
    forms = request.forms
    people.setSafe(forms['name'])

    
@app.post('/newLocation')
def updateLocation(self):
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