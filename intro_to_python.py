''' 
Fall 2021, TSCI 5230
Module: Introduction to Python 
'''


import random # import library
import pandas as pd
import matplotlib.pyplot as plt

''''
Reading data in from a file.

If you have CSV data, use pd.read_csv() instead
'''
dat0 = pd.read_excel('data/sim_veteran.xlsx')

'''
Getting information about your data
'''
dat0
dat0.describe()
dat0.info() # equivalent to R: summary(dat0)
dat0.head() # equivalent to R: head(dat0)


'''Sorting Data'''
dat0.sort_values('time')         # Sort by one columns
dat0.sort_values(['time', 'diagtime']) # Sort by two columns

# Specifying direction of sorting
dat0.sort_values(['time', 'diagtime'], ascending=True) 
dat0.sort_values(['time', 'diagtime'], ascending=False) 
dat0.sort_values(['time', 'diagtime'], ascending=[False,True]) 

'''Extracting columns'''
dat0.time     # in R: dat0$time
dat0['time']   # in R: dat0[["time"]]
dat0[['time', 'diagtime','age']] # in R: dat0[c('time', 'diagtime','age')]
dat0.time
dat0.time > 31 # set up True or False 
dat0[dat0.time > 31] # select rows based on condition

'''Extracting rows and columns'''
# dat0.BMI[ROWSTUFF,COLUMNSTUFF]
#Python: FOO.isin(['BAR','BAZ','BAT']) # in R: R: FOO %in% c('BAR','BAZ','BAT')
dat0.time.between(29,31, inclusive='both')
dat0.age[dat0.time.between(29,31, inclusive='both')]
dat0.loc[dat0.time.between(29,31, inclusive='both'), ['age', 'diagtime']]
dat0.iloc[10:30,2:5]
'''python indexs things starting from 0, so it skipped ro 30 because 0 coutned as a row, same with columns'''

'''assign value to column'''
dat0['foo'] = 10
dat0.head()
dat0['bar'] = 11
dat0.head()

'''Operates on columns inside of a data frame'''
dat0.eval('diagtime-time')

'''plotting'''
dat0.plot.scatter('time', 'diagtime')

plt.show()
