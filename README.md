# Units
Units with classes, records, interfaces, ... with specific information in each one

All code comments into the units are formatted for [PasDoc](https://github.com/pasdoc/pasdoc)


### TWBControl

Contains the uWBControl unit. 
The uWBControl unit contains the definition and implementation of the classes needed to manage a HTML loaded into a TWebBrowser.
You can get information about forms, images and links. You can read and set values of different elements from a Form. You can submit a form too.
That unit work with HTML pages with or without Framesets. In case no exists frameset, this unit create one without name.
Only valid for Windows. If someone wants to transform the unit to multiplatform, I will appreciate it xD

|Framework |Platform  |
|----------|----------|
|VCL       |All       |


### TFBMetaData

Contains the uFBMetaData and uFBMDFireDAC units.
First unit, uFBMetaData, contains the base class TFBMetaData to get information from a Firebird DataBase. You can inherited from this class to establish a database connection to get the information.
Second unit, uFBMDFireDAC, contains the TFBMDFireDAC class that inherited from TFBMetaData to establish a FireDAC connection to get the information.

|Framework |Platform  |
|----------|----------|
|VCL       |All(*)    |
|FMX       |All(*)    |

(*) if the components connection have access to this framework/platform


### TDualList

Contains the uDualList unit. 
The uDualList unit contains the definition and implementation of the classes needed to manage a dual list with a pair of key-value.

|Framework |Platform  |
|----------|----------|
|VCL       |All       |
|FMX       |All       |


### TServices

Contains the uServices unit. 
The uServices unit contains the definition and implementation of the classes needed to manage Windows Services.

|Framework |Platform  |
|----------|----------|
|VCL       |All       |
