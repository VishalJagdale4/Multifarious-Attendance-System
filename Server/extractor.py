print('Importing Extractor... ', end='')
from matplotlib.patches import Rectangle
from matplotlib import pyplot as plt
from mtcnn.mtcnn import MTCNN
import random
import os
import cv2

def extract_faces(image_path, save_here, detected_here, img_num, required_size=(224, 224)):
    
    image = plt.imread(image_path)

    detector = MTCNN()
    faces = detector.detect_faces(image)

    plt.imshow(image)
    ax = plt.gca()

    try:
      os.makedirs(save_here)
    except FileExistsError:
        pass
    else:
        print('Error')

    for face in faces:

        x, y, width, height = face['box']
        x2, y2 = x + width, y + height

        rect = Rectangle((x, y), width, height, fill=False, color='red')
        ax.add_patch(rect)

        face_boundary = image[y:y2, x:x2]
        
        biggest = 0
        
        box=face['box']       
        area = box[3]  * box[2]
        
        if area>biggest:
            biggest=area
            bbox=box 
            
        bbox[0]= 0 if bbox[0]<0 else bbox[0]
        bbox[1]= 0 if bbox[1]<0 else bbox[1]
        
        img = image[bbox[1]: bbox[1]+bbox[3],bbox[0]: bbox[0]+ bbox[2]]  
        img = cv2.resize(img, required_size, 3)
        img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)

        list_of_faces = os.listdir(save_here)
        index = random.choice([x for x in range(1, 121) if x not in list_of_faces])

        cv2.imwrite((f'{save_here}\\{index}.jpg'), img)
        if os.path.getsize(f'{save_here}\\{index}.jpg') <= 10000:
            os.remove(f'{save_here}\\{index}.jpg')
    
    try:
      os.makedirs(f'all presents\\{detected_here}')
    except FileExistsError:
        pass
    else:
        print('Error')
      
    plt.savefig(f'all presents\\{detected_here}\\image_{img_num}.jpg')

print('OK')