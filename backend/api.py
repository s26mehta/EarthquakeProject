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
    return static_file("index.html", root='./html')

@app.route('/file/<filename>')
def serve_static(filename):
    if filename == "map":
        return static_file("map.html", root='html')
    return static_file(filename, root='./html/')

@app.route('/eq')
def function():
    return static_file("resetEarthquake.html", root='html')

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
    return str(people.isEmergency)

@app.post('/setEarthquake')
def set_earthquake_now():
    forms = request.forms
    if forms['eq'] == str(1):
        people.isEmergency = True
    else:
        people.isEmergency = False
    log.debug("setting earthquake to: " + str(people.isEmergency))
    people.writeToFile()
    redirect('/')

@app.get('/getEmergData')
def getEmergData():
    return people.region + " " + people.emergencyType

@app.post('/setEmergData')
def set_earthquake_now():
    forms = request.forms
    people.region = forms['emergencyregion']
    people.emergencyType = forms['emergencytype']
    people.isEmergency = True
    log.debug("setting region to: " + people.region + " Setting type to: " + people.emergencyType)
    people.writeToFile()
    redirect("/map")

@app.get('/getSafe')
def getSafePeople():
    return people.whoIsSafe()
    people.writeToFile()

@app.get('/countSafe')
def getSafePeople():
    return str(people.countSafe())

@app.get('/countUnSafe')
def getSafePeople():
    return str(people.countUnsafe())

@app.get('/getPeople')
def getSafePeople():
    return people.everyone()

@app.get("/getCells")
def getCells():
    return static_file("cells.json", root='.')

@app.post('/newPerson')
def newPerson():
    people.newPerson(request.forms['name'])
    log.debug("new person: " + str(request.forms['name']))
    people.writeToFile()


@app.post('/setStatus')
def setSafePerson():
    forms = request.forms
    log.debug(forms['name'])
    log.debug(forms['name'] + "is trying to set, lat: " + str(forms['lat'] + " lon: " + str(forms['lon'])))
    log.debug(forms['name'] + "isInList: " + str(people.isInList(forms['name'])))
    if people.isInList(forms['name']):
        people.setNewLocation(forms['name'], Location(forms['lat'], forms['lon']))
        try:
            time = datetime.fromtimestamp(int(forms["time"]))
            log.debug(str(forms['name']) + "setting to status: " + str(forms['status']) + "at time: " + str(time))
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