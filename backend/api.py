from bottle import *
from datetime import datetime
from classes import *
import logging
import json

app = Bottle()

logging.basicConfig(filename='log.log', format='%(asctime)s-%(name)s\t-%(levelname)s\t-%(message)s',level=logging.DEBUG)
log = logging.getLogger('log')

people = People()
people.readFromFile()
people.writeToFile()

#######################################################
###                API Routes                       ###
#######################################################

@app.route('/')
def home():
    return static_file("index.html", root='.')

@app.route('/file/<filename>')
def serve_static(filename):
    if filename == "map":
        return static_file("map.html", root='html')
    return static_file(filename, root='./html/')

@app.route('/img/<filename>')
def serve_static(filename):
    return static_file(filename, root='./html/img')

@app.route('/staticPeople')
def staticPeople():
    return static_file("people.json", root='.')

@app.route('/map')
def staticPeople():
    return static_file("map.html", root='./html')

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
    people.writeToFile()

@app.get('/getPeople')
def getSafePeople():
    return people.everyone()

@app.get("/getCells")
def getCells():
    return '[{"name": "cell1", "location": {"lat": 43.473065, "lng": -80.540156}}]'

@app.post('/newPerson')
def newPerson():
    return people.newPerson(request.forms['name'])
    people.writeToFile()


@app.post('/setStatus')
def setSafePerson():
    forms = request.forms
    if people.isInList(forms['name']):
        people.setNewLocation(forms['name'], Location(forms['lat'], forms['lon']))
        try:
            time = datetime.fromtimestamp(int(forms["time"]))
            people.setStatus(forms['name'], int(forms['status']), time)
        except KeyError, e:
            return "Key Error!: " + str(e.message)
        people.writeToFile()
        return "successuflly updated person!"
    else:
        return "failed to update person"

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