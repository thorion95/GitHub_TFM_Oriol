import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

fruits = pd.read_table('TFM_machine_learning_algorithm/fruits.txt')
print(fruits)
fruits.head()
print(fruits.shape)
print(fruits['fruit_name'].unique())
print(fruits.groupby('fruit_name').size())


sns.countplot(fruits['fruit_name'],label="Count")
plt.show()

fruits.drop('fruit_label', axis=1).plot(kind='box', subplots=True, layout=(2,2), sharex=False, sharey=False, figsize=(9,9), 
                                        title='Box Plot for each input variable')
plt.savefig('fruits_box')
plt.show()