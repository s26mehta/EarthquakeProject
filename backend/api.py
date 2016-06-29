from bottle import *
import logging

app = Bottle()


logging.basicConfig(filename='log.log', format='%(asctime)s-%(name)s\t-%(levelname)s\t-%(message)s',level=logging.DEBUG)
log = logging.getLogger('log')

isEarthquake = False

class Person():
    """docstring for Person"""
    def __init__(self, _name, _status):
        self.name = _name
        self.status = _status

    def isSafe(self):
        if self.status == 1: # 1 is safe
            return True
        return False


class People():
    """Object for all people in the database"""
    def __init__(self, _array = []):
        self.array = _array

    def newPerson(self, _name, _status):
        self.array.append(Person(_name, _status))

    def whoIsSafe(self):
        isSafe = []
        for i in self.array:
            if i.isSafe():
                isSafe.append(i)
        return isSafe
        
people = People()


@app.route('/')
def home():
    return static_file("index.html", root='.')

@app.get('/isEarthquake')
def get_earthquake_now():
    return isEarthquake

@app.post('/setEarthquake')
def set_earthquake_now():
    forms = request.forms
    if forms['eq'] == 1:
        isEarthquake = True
    else:
        isEarthquake = False

@app.get('/getSafe')
def getSafePeople():
    return people.whoIsSafe()



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