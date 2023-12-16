from matplotlib import pyplot as plt
from multiprocessing import Process
from time import sleep as slp
from mtcnn import MTCNN
from PIL import Image
import pyrebase
import cv2
import os

def multi_process(process):
    
    while(len(process) >= 5):

        jobs = process[-5:]
        process = process[:-5]

        for job in jobs:
            job.start()
            print(f'{job.pid} --> started')
        
        print('\n')

        for job in jobs:
            job.join()
            print(f'{job.pid} --> done!')
        
        print('\n')
    
    for job in process:
        job.start()
        print(f'{job.pid} --> started')
    
    print('\n')

    for job in process:
        job.join()
        print(f'{job.pid} --> done!')

    print('\n')

def downloadImages(location, student):

    global storage

    counter = 1
    all_images = storage.child(location).list_files()
    download_loc = f'uploads\\{location.split("/")[1]}\\{location.split("/")[2]}\\{student}'

    try:
        os.makedirs(download_loc)
        print(f'{download_loc} created')
    except FileExistsError:
        pass
    else:
        print(f'{download_loc} Error')

    for image in all_images:
        if(location in image.name):
            storage.path = ''
            print('Updater :-> Downloading.... : ' + image.name)
            storage.child(image.name).download(f'{download_loc}\\{counter}.jpg') 

            if os.path.getsize(f'{download_loc}\\{counter}.jpg') < 999:
                os.remove(f'{download_loc}\\{counter}.jpg')
                counter -= 1

            counter += 1
    
    print(f'Updater :-> Student({student}) data downloaded...!')

def storeToDatabase(person):

    uid = person.split("_")[2]
    dept = person.split("_")[0]
    yr = person.split("_")[1]

    folder = "uploads\\"
    database = "database\\"
    location =  f'{database}{dept}\\{yr}\\{uid}'
    uploads = f'{folder}{dept}\\{yr}\\{uid}'

    try:
        os.makedirs(location)
    except FileExistsError:
        pass
    else:
        print('Error')

    counter = 1

    for image in os.listdir(uploads):
        faces = extract((f'{uploads}\\{image}'), location, str(counter))
        counter += 1
    
def extract(image_path, save_here, filename):
    
    image = plt.imread(image_path)
    detector = MTCNN()
    faces = detector.detect_faces(image)
    dimension = (224,224)
    img = Image.open(image_path)
    
    counter = 1

    for face in faces:
        biggest = 0
        
        box=face['box']       
        area = box[3]  * box[2]
        
        if area>biggest:
            biggest=area
            bbox=box 
            
        bbox[0]= 0 if bbox[0]<0 else bbox[0]
        bbox[1]= 0 if bbox[1]<0 else bbox[1]
        
        img = image[bbox[1]: bbox[1]+bbox[3],bbox[0]: bbox[0]+ bbox[2]]  
        img = cv2.resize(img, dimension, 3)
        img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
        cv2.imwrite((f'{save_here}\\{filename}_{counter}.jpg'), img)
        if os.path.getsize(f'{save_here}\\{filename}_{counter}.jpg') <= 10000:
            os.remove(f'{save_here}\\{filename}_{counter}.jpg')
            counter -= 1
        counter += 1

def updater():

    global database
    global storage

    data = database.get().val()['Jobs']['Update Database']
    departments = data.keys()

    detection_jobs = []
    download_jobs = []

    for department in departments:
        if(data[department] != ''):
            students = data[department].keys()
            for index, student in enumerate(students):
                if(data[department][student]['remaining'] == 'true'):

                    batch = department.split('_')

                    download_jobs.append(Process(
                        target=downloadImages, 
                        args=((f'Student Faces/{batch[0]}/{batch[1]}/{student}'), student,)
                    ))

                    database.child(f'Jobs/Update Database/{department}/{student}').update(
                        {'remaining':'false'}
                    )

                    detection_jobs.append(Process(
                        target=storeToDatabase, 
                        args=(f'{batch[0]}_{batch[1]}_{student}',)
                    ))

                else:
                    slp(1)

    if(len(download_jobs) > 0):
        multi_process(download_jobs)

    if(len(detection_jobs) > 0):
        multi_process(detection_jobs)

db_url = 'https://multifarious-attendance-system-default-rtdb.firebaseio.com/'
stg_url = 'multifarious-attendance-system.appspot.com'

config = {
"apiKey": "",
"authDomain": "",
"projectId": "",
"databaseURL": db_url,
"storageBucket": stg_url,
"messagingSenderId": "",
"appId": "",
"serviceAccount": "firebaseKey.json"
}

app = pyrebase.initialize_app(config)

storage = app.storage()
database = app.database()

if __name__ == '__main__':
    while True:
        updater()