print('Importing Connector... ', end='')

import pyrebase

class Firebase:

    db_url = 'https://multifarious-attendance-system-default-rtdb.firebaseio.com/'
    stg_url = 'multifarious-attendance-system.appspot.com'
    app = None

    def __init__(self):

        print('Connecting to Firebase....', end = '')

        config = {
        "apiKey": "",
        "authDomain": "",
        "projectId": "",
        "databaseURL": self.db_url,
        "storageBucket": self.stg_url,
        "messagingSenderId": "",
        "appId": "",
        "serviceAccount": "firebaseKey.json"
        }

        self.app = pyrebase.initialize_app(config)

        print('OK')

    def getStorage(self):
        return self.app.storage()

    def getDatabase(self):
        return self.app.database()
        
print('OK')