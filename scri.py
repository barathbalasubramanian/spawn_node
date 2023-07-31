from ultralytics import YOLO
import cv2
import sys
from PIL import Image
import io

if len(sys.argv) > 1:
    dataFromNodeScript = sys.argv[1]

classes = ['MildDemented' , 'ModerateDemented' , 'NonDemented' ,'SevereDemented' , 'VeryMildDemented']

model = YOLO('models\weights.pt')
im2 = cv2.imread("image\scan_image.png")
results = model.predict(source=im2)
cv2.imwrite('image\save.png',results[0].plot())
pre = results[0].boxes.cls.tolist()  
p = []
p.append(classes[int(pre[0])])
print(p)
