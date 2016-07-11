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

@app.post('/newPerson')
def newPerson():
    return people.newPerson(request.forms['name'])
    people.writeToFile()


@app.post('/setStatus')
def setSafePerson():
    forms = request.forms
    people.setNewLocation(forms['name'], Location(forms['lat'], forms['lon']))
    if forms['status'] == "safe":
        try:
            time = datetime.fromtimestamp(int(forms["time"]))
            people.setSafe(forms['name'], time)
        except KeyError, e:
            pass
        people.setSafe(forms['name'])
    elif forms['status'] == "unsafe":
        forms = request.forms
        people.setUnSafe(forms['name'], forms['severity'])
    people.writeToFile()

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