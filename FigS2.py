import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


fig, ax = plt.subplots(2, 1, figsize=(20,10), tight_layout=True)

df = pd.DataFrame.from_csv('MBARC/runtimes.csv',index_col=None)
sns.catplot(x='size', y='time',hue='tool', data=df, ax=ax[0], kind="bar", palette="muted", legend=False)
ax[0].set(xlabel="size [Gb]", ylabel='time [s]')

df = pd.DataFrame.from_csv('MBARC/memory.csv',index_col=None)
sns.catplot(x='size', y='memory',hue='tool', data=df, ax=ax[1], kind="bar", palette="muted", legend_out=True)
ax[1].set(xlabel="size [Gb]", ylabel='memory [GB]')

fig.savefig('FigS2.pdf')
