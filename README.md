# itm6hub
Non-Official reusable IBM Tivoli Monitoring Server (HUB TEMS) Docker image deployment

### How to cook:

1. Download IBM Tivoli Monitoring V6.3.0.7 Base, Linux (64 Bit Env.), English (PartNumber CNMD8EN). (https://www-01.ibm.com/support/docview.wss?uid=swg24041633)
2. Clone this repository and extract the files
3. Inside your local directory, run: 
  $ docker build -t your-docker-user-tag/itm6hub . 
4. Build process can take up to 10min, make sure your file name matches the ITM Installation media described in the docker file

Note: My deployment is setup up to run as IP.SPIPE protocol, this parameter as all the others can be changed in the file ms_config.txt.

  
### How to run:

IBM Tivoli Monitoring HUB TEMS uses the following ports for communication:
* 1918, 1920, 3660, 3661.

$ docker run --name='your-container-name' -p 1918:1918 -p 1920:1920 -p 3660:3660 -p 3661:3661 your-docker-hub-tag/itm6hub

### How to stop the application gracefully:

$ docker kill --signal="SIGTERM" 'your-container-name'
 
