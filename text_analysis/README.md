# Text analysis

The metadata analysis folder consists of:
<ol>
  <li>Jupyter Notebook <code>bigrams.ipynb</code>, which calculates the frequency of bigrams containing the word *kodu*. The code is meant to be used in the <a href="https://jupyter.hpc.ut.ee/">JupyterHub environment</a>, which user guide can be found in <a href="https://digilab.rara.ee/en/tools/access-to-dea-texts/#uagb-tabs__tab1">Digilab</a>. The results of the code appear in Table 1 of the thesis.</li>
  <li>R script <code>collocates.R</code> calculates statistically significantly frequently co-occurring wordpairs, where one of words is *home*. The results of the script are presented in Table 2.</li>
  <li>File <code>kodu_concs.txt</code>, which consists of 100 character context to right and left from the word "home". The file is downloaded from <code>bigrams.ipynb</code>, and used both in <code>collocates.R</code> and <code>topic_modelling.ipynb</code>.</li>
  <li>Locally useable Jupyter Notebook <code>topic_modelling.ipynb</code>. The results of the topic modelling is in Table 3.</li>
  <li>File <code>estonian-stopwords-lemmas.txt</code>, downloaded from <a href="https://datadoi.ee/handle/33/78">DataDOI</a>. The file is used in all the scripts.</li>
</ol>
