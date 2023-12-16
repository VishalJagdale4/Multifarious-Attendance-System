print('Importing Model... ', end='')

from keras_vggface.utils import preprocess_input
from keras_vggface.vggface import VGGFace
from numpy import asarray

def get_model_score(faces):

    samples = asarray(faces, 'float32')
    samples = preprocess_input(samples, version=2)

    vgg16 = VGGFace(model='vgg16',
      include_top=False,
      input_shape=(224, 224, 3),
      pooling='avg')

    senet50 = VGGFace(model='senet50',
      include_top=False,
      input_shape=(224, 224, 3),
      pooling='avg')

    resnet50 = VGGFace(model='resnet50',
      include_top=False,
      input_shape=(224, 224, 3),
      pooling='avg')

    vgg16_score = vgg16.predict(samples)
    senet50_score = senet50.predict(samples)
    resnet50_score = resnet50.predict(samples)

    return [vgg16_score, senet50_score, resnet50_score]
print('OK')