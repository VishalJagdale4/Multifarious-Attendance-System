print('Initializing...')

from multiprocessing import Process, Manager, Pool
from scipy.spatial.distance import cosine
from markAttendnace import mark
from matplotlib import pyplot as plt
from datetime import datetime as dt
from extractor import extract_faces
from model import get_model_score
import matplotlib.image as mpimg
from connecter import Firebase
import multiprocessing
from PIL import Image
import os

fb = Firebase()
database = fb.getDatabase()
storage = fb.getStorage()

def compare(args):

    face_1, face_2, score = args

    faces = [plt.imread(face_1), plt.imread(face_2)]
    model_score = get_model_score(faces)

    total_score = 0
 
    for model in model_score:
        total_score += cosine(model[0], model[1])
    if(total_score/3) <= 0.25:
      score.value += 1

def scheduler(processes):

  while len(processes) >= 5:

    jobs = processes[-5:]
    processes = processes[:-5]

    [job.start() for job in jobs]
    [job.join() for job in jobs]
        
  if(len(processes) > 0):
    [job.start() for job in processes]
    [job.join() for job in processes]

def downloadImages(location, data_loc):
  
  global storage
  storage_loc = f'Attendance Record/{location[0]}/{location[1]}/{location[2]}/{location[3]}'

  counter = 1
  all_images = storage.child(storage_loc).list_files()

  try:
      os.makedirs(data_loc)
  except FileExistsError:
      pass
  else:
      print('Error')

  for image in all_images:
      if(storage_loc in image.name):
        storage.path = ''
        print('Downloading....!')
        storage.child(image.name).download(f'{data_loc}\\{counter}.jpg') 

        if os.path.getsize(f'{data_loc}\\{counter}.jpg') < 999:
          os.remove(f'{data_loc}\\{counter}.jpg')
          counter -= 1

        counter += 1
  
def recognize(student, present, attendees, std, pst):

  comparisions = []
  score = Manager().Value('i', 0) 
  for img in os.listdir(student):
    comparisions.append(Process(target=compare, args=((present, f'{student}{img}',score),)))
  scheduler(comparisions)
  attendees[pst].update({std:score.value})
  return score

def attendance():

  global database
  global storage

  attendees = dict()
  attendance_list = []

  data = database.get().val()['Jobs']['Attendance']
  departments = data.keys()

  recognition_jobs = []
  extraction_jobs = []

  for attendance in data.keys():
    
    batch = attendance.split('_')
    data_loc = f'attendance images\\{batch[0]}\\{batch[1]}\\{batch[2]}\\{batch[3]}'
    save_faces_here = f'presents\\{batch[0]}\\{batch[1]}\\{batch[2]}\\{batch[3]}'
    detected_here = f'{batch[0]}\\{batch[1]}\\{batch[2]}\\{batch[3]}'
    downloadImages(batch, data_loc)

    for index, image in enumerate(os.listdir(data_loc)):
      image_path = f'{data_loc}\\{image}'
      extraction_jobs.append(Process(target=extract_faces,
      args=(image_path, save_faces_here, detected_here, index,)))    
    
    scheduler(extraction_jobs)
    extraction_jobs = []

    database_loc = f'database\\{batch[0]}\\{batch[1]}'
    database_ls = os.listdir(f'database\\{batch[0]}\\{batch[1]}')

    for present in os.listdir(save_faces_here):
      attendees.update({present:{}})
      print(f'Working on {present}')

      for student in database_ls:
        if recognize(f'{database_loc}\\{student}\\', f'{save_faces_here}\\{present}', attendees, student, present).value>1:
          if(student in database_ls):
            database_ls.remove(student)
            attendance_list.append(student)
          break

        print(attendees)

    
      attendance_list=[]
      mark(attendance_list, batch, database)

      database.child(f'Jobs/Attendance/{batch[0]}_{batch[1]}_{batch[2]}_{batch[3]}').update(
                            {'remaining':'false'}
                    )
  
if __name__ == '__main__':
  attendance()