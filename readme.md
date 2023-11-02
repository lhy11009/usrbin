## usrbin

This is a summary of useful scripts and files on Linux

authored by: lhy11009

### files

##### system\_files

These are useful system files.

ssh\_config: an example of the .ssh/config file.

### bash scripts

#### server.sh

1. sync files on local and remote machine

In the example, the "TwoDSubduction" is a name for the project, while "EBA\_CDPT9" is a subdirectory I want to sync.

    Usr_server sync ucd TwoDSubduction EBA_CDPT9

Then the option all will sync everything.
This is the command to use when syncing with back up server
    
    Usr_server sync ucd TwoDSubduction all

Adding another flag 1 will exclude the output files from ASPECT, VISIT, etc. from the remote.
But it will sync every modification from the local machine.
This is the togo command for syncing the project directory between the workstation and local machines.

    Usr_server sync ucd TwoDSubduction all 1

Flag 2 will also exclude the outputs but include the folder img
This is command to use when working on a windows machine, to sync all the figures produced on the server.

    Usr_server sync ucd TwoDSubduction {case_name} 2

Flag 3 will only sync from server and exclude all the restart file, thus is used for copying case data from server.

    Usr_server sync peloton TwoDSubduction {case_name} 3
    Usr_server sync peloton EntropySub {case_name} 3
    Usr_server sync stampede2 ThDSubduction {case_name} 3
    Usr_server sync frontera ThDSubduction {case_name} 3

Flag 4 will only sync from server and include all the restart file thus is used for copying case data completely from server.
    
    Usr_server sync stampede2 ThDSubduction {case_name} 4