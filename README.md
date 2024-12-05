# drift-ichthyo
Code for publishing YBFMP drift invertebrate update and ichthyoplankton data to EDI


## Notes on folders and process
The actual processing of data and code was done in the main drift-ichthyo-publish folder, using the .Rmd files. Once the raw data from drift data and ichthyo data were cleaned in LTPhysicalData_QAQC, Drift_QAQC, and Ichthyo_QAQC, the data were written to their respective R_write folders. You will find any troubleshooting done in the troubleshooting scripts folder and how sensor data was downloaded from CDEC in the Download CDEC LIS sensor data file. 


## Additional metadata
All of the SOPs and description of the QA/QC processes are located in the metadata/methods_references folder. There is also a copy of the diagram showing how all the tables are related to each other.
