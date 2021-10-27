''' Introduction to NumPy '''

import numpy as np
from sklearn.linear_model import LinearRegression
import pandas as pd

b = np.array([1,5,7,8])

print(b)

A = np.array([[1,7,5,4], [7,9,4,5]])
print(A)

B = np.array([[1,7,5,4], [7,9,5]])
B # it turns into lists

C = A.copy()
C

A.shape

A.transpose()

b-3
A-b

'''
Fitting a linear regression model
'''
LRModel = LinearRegression()
yy = np.array(iris["Petal.Length"])
yy
xx = np.array(iris[["Sepal.Length","Sepal.Width"]])
LRModel.fit(xx, yy)
LRModel.intercept_
LRModel.coef_

C
D = np.array([4,6,2,7])
E = np.vstack([C,D])
F = np.array([4,7,9]).reshape(3,1)
G = np.hstack([E, F])

H = G+1
G += -4
