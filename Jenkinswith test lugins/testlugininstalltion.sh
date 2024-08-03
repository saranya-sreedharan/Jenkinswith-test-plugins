#!/bin/bash
# This script will install Jenkins and testing plugins on Ubuntu 20.04

# Colors for text formatting
RED='\033[0;31m'  # Red colored text
NC='\033[0m'      # Normal text
YELLOW='\033[33m'  # Yellow Color
GREEN='\033[32m'   # Green Color
BLUE='\033[34m'    # Blue Color




# Function to display error messages
display_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    display_error "This script must be run as root."
fi

# Update system
echo -e "${YELLOW}...Updating the system...${NC}"
if ! sudo apt update; then 
    display_error "System failed to update."
fi

# Install OpenJDK 11
echo -e "${YELLOW}...Installing java before installing jenkins...${NC}"
if ! sudo apt install -y openjdk-11-jdk; then
    display_error "Failed to install OpenJDK 11."
fi

echo -e "${YELLOW}...check the wget is installing...${NC}"

if ! command -v wget &> /dev/null; then
    echo -e "${YELLOW}...Installing wget...${NC}"
    sudo apt-get install -y wget || display_error "Failed to install wget."
fi


# Add Jenkins keyring
echo -e "${YELLOW}...Add Jenkins library...${NC}"
if ! sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key; then
    display_error "Failed to download Jenkins keyring."
fi


# Add Jenkins apt repository entry
echo -e "${YELLOW}...Add Jenkins apt repository...${NC}"
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update apt repository
echo -e "${YELLOW}...Update apt repository...${NC}"
if ! sudo apt-get update; then
    display_error "Failed to update apt repository."
fi

# Install Jenkins
echo -e "${YELLOW}...Installing Jenkins...${NC}"
if ! sudo apt-get install -y jenkins; then
    display_error "Failed to install Jenkins."
fi

# Display Jenkins initial admin password

echo -e "${YELLOW}...Note the password to login to Jenkins...${NC}"

jenkins_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
if [ -z "$jenkins_password" ]; then
    display_error "Failed to retrieve Jenkins initial admin password."
else
    echo -e "${GREEN}Jenkins installed successfully.${NC}"
    echo -e "${YELLOW}Jenkins initial admin password:${NC} $jenkins_password"
    echo -e "${BLUE}Jenkins is running on port 8080.${NC}"
fi

echo -e "${YELLOW}...Taking the iadress of the instance...${NC}"

ip_service="ifconfig.me/ip"  # or "ipecho.net/plain"

public_ip=$(curl -sS "$ip_service")


echo -e "${YELLOW}...installing the jenkins cli...${NC}"

if ! wget http://$public_ip:8080/jnlpJars/jenkins-cli.jar;then
   echo -e "${RED}...Failed to install jenkinsCLI...${NC}"
else
   echo -e "${GREEN}...Jenkinscli installed successfully ...${NC}"

fi

sudo systemctl restart jenkins

echo -e "${YELLOW}...for Jenkinscli authentication create a token  (next we need to create a authentication token. (go to the profile --> then configure--->Add new token --->generate --->Coy the token and store it some where )...${NC}"

echo -e "${YELLOW}Enter your username:${NC}"
read -r user_name

echo -e "${YELLOW}Enter your token:${NC}"
read -r token

# Authentiocating with user token
echo -e "${YELLOW}...Authenticate usertoken for login...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token; then
  echo -e "${RED}Failed to login to jenkins cli${NC}"

else 
   echo -e "${GREEN}Successfully login ${NC}"
fi 

#Installing behave plugin for integration testing
echo -e "${YELLOW}...Installing behave python Integration testing plugin...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin behave-testresults-publisher; then
  echo -e "${RED}Failed to install behave plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the behave plugin${NC}"
fi 

# Installing robot Framework
echo -e "${YELLOW}...Installing RobotFramework plugin for functional testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin Robot; then
  echo -e "${RED}Failed to install robot plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the robot plugin${NC}"
fi 

#installing performance lugin for performance testing
echo -e "${YELLOW}...Installing performanc plugin for performanc testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin performance; then
  echo -e "${RED}Failed to install performance plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the performance plugin${NC}"
fi 

#installing lighthouse lugin for performance testing
echo -e "${YELLOW}...Installing lighthouse-report plugin for performance testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin lighthouse-report; then
  echo -e "${RED}Failed to install lighthouse-report plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the lighthouse-report plugin${NC}"
fi 


#installing performance lugin for performance testing
#echo -e "${YELLOW}...Installing lighthouse-report plugin for functional testing...${NC}"
#if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin lighthouse-report; then
#  echo -e "${RED}Failed to install lighthouse-report plugin through CLI${NC}"
#else 
 #  echo -e "${GREEN}Successfully installed the lighthouse-report plugin${NC}"
#fi 

#installing ZAP Plugin for security testing
echo -e "${YELLOW}...Installing ZAP plugin for security testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin ZAP; then
  echo -e "${RED}Failed to install ZAP plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the ZAP plugin${NC}"
fi 

#installing Gatling Plugin for Load testing
echo -e "${YELLOW}...Installing gatling plugin for load testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin Gatling; then
  echo -e "${RED}Failed to install Gatling plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the Gatling plugin${NC}"
fi 

#installing sauce-ondemand Plugin for compactibility testing
echo -e "${YELLOW}...Installing sauce-ondemand plugin for comactibility testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin sauce-ondemand; then
  echo -e "${RED}Failed to install sauce-ondemand plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the sauce-ondemand plugin${NC}"
fi 


#installing xunit Plugin for unit testing
echo -e "${YELLOW}...Installing xunit plugin forunitl testing...${NC}"
if ! java -jar jenkins-cli.jar -s http://$public_ip:8080/ -auth $user_name:$token install-plugin xunit; then
  echo -e "${RED}Failed to install xunit plugin through CLI${NC}"
else 
   echo -e "${GREEN}Successfully installed the xunit plugin${NC}"
fi 


#java -jar jenkins-cli.jar -s http://54.161.192.42:8080/ -auth saranya:11ab63a98ad59d8d12b7496c2ecdce3e8b install-plugin CodeSonar
#java -jar jenkins-cli.jar -s http://54.161.192.42:8080/ -auth saranya:11ab63a98ad59d8d12b7496c2ecdce3e8b install-plugin Sonar

sudo systemctl restart jenkins

echo -e "${GREEN}...Scrit Executed successfully..${NC}"
