import seaborn as sns
import pandas as pd
import glob
import matplotlib.pyplot as plt

df = None
for d in glob.glob("MBARC/loo_results/*"):
    trues = 0.0
    totals = 0.0
    for line in open("{}/queries_{}/tree_decisions.txt".format(d, d)):
        line = line.strip().split('\t')
        if line[2] == d:
            totals +=1
            if line[3] == "True":
                trues +=1
    if "aceae" in d:
        level = 'Family'
    elif "ales" in d:
        level = 'Order'
    p_df = pd.DataFrame({"frac":(trues/totals)*100, "level":level}, index=[d])
    if df is None:
        df = p_df
    else:
        df = df.append(p_df)


fig, ax = plt.subplots(figsize=(10,6), tight_layout=True)

sns.violinplot(x="level", y="frac", data=df, inner="box", cut=0, ax=ax)
# ax = sns.boxplot(x="level", y="frac", data=df)
ax.set_ylabel("fraction of recoverd proteins [%]")
ax.set_xlabel("")
fig.savefig('FigS3.pdf', orientation='landscape', dpi=500)
