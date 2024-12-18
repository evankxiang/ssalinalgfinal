# -*- coding: utf-8 -*-
"""proof.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/11vhn-m2vPZHIDoNygnUNoCBNHQ3-4AFe
"""

import cv2
import numpy as np
import matplotlib.pyplot as plt
print(image)
def gaus2d(x=0, y=0, mx=0, my=0, sx=1, sy=1):
    return 1. / (2. * np.pi * sx * sy) * np.exp(-((x - mx)**2. / (2. * sx**2.) + (y - my)**2. / (2. * sy**2.)))
x = np.linspace(-5, 5)
y = np.linspace(-5, 5)
x, y = np.meshgrid(x, y)
image = gaus2d(x, y) * 255
image = np.ones((49,49))*255
image[24][24] = 0
gblur = cv2.GaussianBlur(image,(31,31),3.5,3.5)
bblur1 = cv2.boxFilter(image,-1,(5,5))
bblur2 = cv2.boxFilter(bblur1,-1,(5,5))
bblur3 = cv2.boxFilter(bblur2,-1,(5,5))
bblur4 = cv2.boxFilter(bblur3,-1,(5,5))
bblur5 = cv2.boxFilter(bblur4,-1,(5,5))
bblur6 = cv2.boxFilter(bblur5,-1,(5,5))

plt.figure(figsize=(18,3))

plt.subplot(1,7,1)
plt.title("Input")
plt.imshow(image, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,2)
plt.title("Box Blur - 1 Pass")
plt.imshow(bblur1, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,3)
plt.title("Box Blur - 2 Passes")
plt.imshow(bblur2, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,4)
plt.title("Box Blur - 3 Passes")
plt.imshow(bblur3, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,5)
plt.title("Box Blur - 4 Passes")
plt.imshow(bblur4, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,6)
plt.title("Box Blur - 5 Passes")
plt.imshow(bblur5, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,6)
plt.title("Box Blur - 6 Passes")
plt.imshow(bblur6, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.subplot(1,7,7)
plt.title("Gaussian Blur")
plt.imshow(gblur, cmap='Blues')
plt.gca().get_xaxis().set_visible(False)
plt.gca().get_yaxis().set_visible(False)

plt.tight_layout()
plt.savefig("box.jpg", facecolor='white', dpi=300)
plt.show()

