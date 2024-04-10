# zeek
A scalable and flexible way to monitor a network. 

The main objective for our tool is the following: 
- Create a container that is able to contain network analysis components that would allow a machine to capture all of the logs produced on a given network.
- Be able to visualize the logs that were produced by the network logger, and create a visual representation of the traffic on the network.
- At the end of the project, the goal is to have a minimum amount of configuration required for the end user during setup.
- Documentation to be provided for future use of the project.

The following is included in this github repository: 
- Zeek configuration script
- Keys File (See below for information)
- Zeek Configuration files
- Docker File
- Docker Compose File
- Documentation and research notes completed in the Winter of 2024

*Note\* It is NOT RECOMMENDED to keep the same keys as provided in the "keys" folder. You should make your own keys and replace the "known_hosts" folder with your own. 

## Research Documentation: 
All research documentation can be found in the Document Links file: 
(https://github.com/Cole-Tompsett/zeek/blob/main/Document%20Links.md)

## Configuration
To effectively use this tool you will need to appropriately configure the following:
- compose file
- Zeek Config Script
- Keys folder

For information on how to configure these navigate to the folder of the files you want to configure and then enter the "Quick_Start" folder which will guide you on how to configure it


## Usage
```bash
docker-compose build
docker-compose up -d
```

## Graylog Tool
The following is the Graylog tool that is also aligned to the Zeek tool:
(https://github.com/Cole-Tompsett/graylog)
