import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

MBARC_genera = ['Clostridium','Ruminiclostridium','Coraliomargarita',
    'Corynebacterium','Desulfosporosinus','Desulfotomaculum','Echinicola',
    'Escherichia','Fervidobacterium','Frateuria','Halovivax','Hirschia',
    'Olsenella','Pseudomonas','Salmonella','Segniliparus','Sediminispirochaeta',
    'Meiothermus','Natronobacterium','Natronococcus','Nocardiopsis',
    'Streptococcus','Terriglobus','Thermobacillus']

df = pd.read_csv("kraken/SRR3656745.report", sep="\t", header=None)

df = df[df[3] == "G"]
df = df.sort_values(by=1, ascending=True)
df = df[df[1] > 10000]

colors = list(df.apply(lambda x: 'red' if any([x[5].lstrip() == t for t in MBARC_genera]) else 'black', axis=1))#

fig = plt.figure()
ax = df[1].plot(kind="barh", color=colors, logx=True, figsize=(7,5))
ax.set_xlabel("no. of assigned reads")
ax.set_ylabel("Genera sorted by no. of assigned reads")
ax.set_yticklabels([])
ax.set_yticks([])
plt.plot(0, 0, color='black')
plt.plot(0, 0, color='red')
ax.legend(["non-MBARC genera", 'MBARC genera'])
fig.savefig('FigS4.pdf')
