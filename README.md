# openRAL Boot Sequence

Example implementation of a boot sequence for a software component, that loads it's own environment as a graph of RalObjects.

The Boot Sequence does the following:
1. Loads a RalObject from a local file
2. The RalObject contains 3 informations (SpecificProperties) for the further boot sequence:
   1. `localDatabaseConnection` : a string for the connection to a local database
   2. `remoteDatabaseConnectionUID` : the uid of another RalObject, that contains the informations to connect to a remote database
   3. `discoveryDimensions` the dimensions of the discovery process
3. The Boot Sequence connects to the local database
4. Execution of the local discovery
   1. searches for the root node in the local database defined by a RALType
   2. recursive discovery of all RalObjects starting with the root node
5. Loads the RalObject from the remote database defined by the `remoteDatabaseConnectionUID`
6. Tries to connect to the remote database using the informations form the RalObject of the previous step
7. Execution of the remote discovery
   1. searches for the root node in the remote database defined by a RALType
   2. recursive discovery of all RalObjects starting with the root node
8. returns the result of the BootSequence as two GraphNodes, one for the local discovery, one for the remote discovery