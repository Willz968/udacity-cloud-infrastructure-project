# CD12352 - Infrastructure as Code Project Solution

## Spin up instructions
1. Open Bash terminal.
2. Change directory to the 'starter' folder: `$ cd starter`
3. Run the script: `$ bash script.sh`
4. Select the template you would like to execute (Network or Application resources) by inputting the corresponding Number.
    - `Network` resources will need to first be deployed, before `Application` resources may be deployed.
5. Select the execution mode you would like to use (Deploy, Delete, Preview) by inputting the corresponding Number.
    - To Spin up resources, select `Deploy`, or `Preview` if you would like to first preview changes.
6. Wait for CloudFormation to finish applying your changes.


## Tear down instructions
1. Open Bash terminal.
2. Change directory to the 'starter' folder: `$ cd starter`
3. Run the script: `$ bash script.sh`
4. Select the template you would like to execute (Network or Application resources) by inputting the corresponding Number.
    - `Application` resources will need to first be deleted, before `Network` resources may be deleted.
5. Select the execution mode you would like to use (Deploy, Delete, Preview) by inputting the corresponding Number.
    - To Tear down resources, select `Delete`.
6. Wait for CloudFormation to finish applying your changes.