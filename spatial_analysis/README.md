# Spatial analysis

Spatial analysis is the most complex stage of analysis. The workflow is illustrated in thesis Figure 5:
<img src="https://github.com/user-attachments/assets/7c15b14c-a21f-41a8-8a5d-7c5aa8714f9f" width="400">

The main files and scripts of the spatial analysis folder are:
<ol>
  <li>Jupyter Notebook <code>NER.ipynb</code>, which identifies locations from the text. The Jupyter Notebooks in this folder are all locally hosted. This step corresponds to the workflow phase <i>NER</i>.</li>
  <li>Jupyter Notebook <code>lemmatisation.ipynb</code>, which lemmatises the results of the text file obtained from <code>NER.ipynb</code>. This step corresponds to the workflow phase <i>Lemmatisation</i>.</li>
  <li>R script <code>unique_and_top_locations.R</code>. This corresponds to both <i>Cleaning the data</i> and <i>Extracting unique values</i> phases. The script generates three files, although for simplification only <code>unique_august_91_locations.txt</code> is added as an example.</li>
  <li>R script <code>top_locations_barplot.R</code> creates a barplot, visualising the top 20 most frequent place names.</li>
  <li>Jupyter Notebook <code>geocoding.ipynb</code> uses the Geocoding API of Google to match the identified locations with coordinates.</li>
  <ol>
  <li>Another option is to use the <code>merged_coordinates.txt</code> file and connect detected place names with coordinates that are merged across all the results with R script <code>merging_values_with_coordinates.R</code>.</li>
  </ol>
  <li>R script <code>extracting_places_in_estonia.R</code> extracts locations within the borders of Estonia based on the most farthest coordinates among cardinal directions. These steps correspond to workflow phase <i>Geocoding</i>.</li>
  <li>R script <code>merging_unique_values_by_decade.R</code> merges the results of newspapers from a specified decade. This is an example of the workflow phase <i>Merging or dividing the data</i>.</li>
  <li>The last phase of the workflow is carried out in open source platform QGIS. The file created by the script <code>extracting_places_in_estonia.R</code> is uploaded as a Delimited Text Layer. The base map is downloaded from <a href="https://geoportaal.maaamet.ee/eng/spatial-data/administrative-and-settlement-division-p312.html">Estonian Land Board</a> and added as a Vector Layer. This is the final step of the workflow, i.e <i>Visualising the data with QGIS</i>.</li>
</ol>

Data folder:
<ol>
  <li>Example file <code>august_91.txt</code>, which is used for answering the second research question. All the other files that are created in the process start from this file.</li>
  <li>Merged coordinates file <code>merged_coordinates.txt</code>, which includes all the coordinates that were identified during the process. This could be used for merging smaller samples since only certain amount of requests are free with Geocoding API.</li>
</ol>
