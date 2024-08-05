# Spatial analysis

Spatial analysis is the most complex stage of analysis. The workflow is illustrated in thesis Figure 5:
<img src="https://github.com/user-attachments/assets/7c15b14c-a21f-41a8-8a5d-7c5aa8714f9f" width="500">

The main files and scripts of the spatial analysis folder are:
<ol>
  <li>Jupyter Notebook <code>NER.ipynb</code>, which identifies locations from the text. The Jupyter Notebooks in this folder are all locally hosted. This step corresponds to the workflow phase <i>NER</i>.</li>
  <li>Jupyter Notebook <code>lemmatisation.ipynb</code>, which lemmatises the results of the text file obtained from <code>NER.ipynb</code>. This step corresponds to the workflow phase <i>Lemmatisation</i>.</li>
  <li>R script <code>unique_and_top_locations.R</code>. This corresponds to both <i>Cleaning the data</i> and <i>Extracting unique values</i> phases. The script generates three files, although for simplification only <code>unique_august_91_locations.txt</code> is added as an example.</li>
  <li>R script <code>top_locations_barplot.R</code> creates a barplot, visualising the top 20 most frequent place names.</li>
  <li>Jupyter Notebook <code>geocoding.ipynb</code> uses the Geocoding API of Google to match the identified locations with coordinates.</li>
  <li>R script <code>extracting_places_in_estonia.R</code> extracts locations within the borders of Estonia based on the most farthest coordinates among cardinal directions. Fifth and sixth step correspond to workflow phase <i>Geocoding</i>.</li>
</ol>

Merging multiple datasets:
<ol>
  <li>First item</li>
  <li>Second item</li>
  <li>Third item</li>
  <li>Fourth item</li>
</ol>

Data folder:
<ol>
  <li>Example file <code>august_91.txt</code>, which is used for answering the second research question./li>
  <li>Second item</li>
  <li>Third item</li>
  <li>Fourth item</li>
</ol>
