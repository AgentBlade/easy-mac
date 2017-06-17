
#!/bin/bash                                                                                                                             
#                                                                                                                                       
#Anonymity is a serious topic and leaving traces like your MAC                                                                          
#will eventually screw up your efforts, this script makes it less                                                                       
#annoying to take action by changing the MAC for you.                                                                                   
#                                                                                                                                       
#Scripted by AgentBlade a.k.a. GRX78FL                                                                                                  
#                                                                                                                                       
# https://github.com/AgentBlade                                                                                                         
# https://dev.parrotsec.org/GRX78FL                                                                                                     
#                                                                                                                                       
# This script is free software as defined by                                                                                            
# the GNU General Public License v3 or higher.                                                                                          
#                                                                                                                                       
# For more details about the licencing please                                                                                           
# visit https://www.gnu.org/licenses/gpl.html                                                                                           
#                                                                                                                                       
                                                                                                                                        
                                                                                                                                        
if [[ $EUID -ne 0 ]] ; then                                                                                                             
    echo -ne "Sorry, you need root's permission to execute this script.\n" #formalities, DAC is the real deal here.                     
    exit 1                                                                                                                              
fi                                                                                                                                      
                                                                                                                                        
echo -en "\n"                                                                                                                           
                                                                                                                                        
if [[ $1 = "new" ]] ; then                                                                                                              
    service network-manager stop #stop network-manager
    for interface in $(ls -I "lo" /sys/class/net/) ; do  #enumerating network interfaces, excluding loopback                            
        echo -en "MAC-CHANGING "$interface"!\n"                                                                                         
        ip link set $interface down                                                                                                     
        macchanger -A $interface        #and changing the mac addresses                                                                 
        ip link set $interface up                                                                                                       
        sleep 0.5                                                                                                                       
        echo -en "\n"                                                                                                                   
    done                                                                                                                                
    service network-manager start    #restart the network manager                                                                     
    else                                                                                                                                
        if [[ $1 = "fixed" ]] ; then                  
        service network-manager stop
            for interface in $(ls -I "lo" /sys/class/net/) ; do                                                                         
                read -p "You've chosen `echo "'$1'"`, enter a MAC for "$interface" please: " fmac                                       
                echo -en "MAC-CHANGING "$interface"!\n"                                                                                 
                ip link set $interface down                                                                                             
                macchanger -m $fmac $interface                                                                                          
                ip link set $interface up                                                                                               
                sleep 0.5                                                                                                               
                echo -en "\n"                                                                                                           
            done                                                                                                                        
            service network-manager start                                                                                             
        else                                                                                                                            
            echo -en "Usage: $(basename $0) [ new | fixed ]\n\n"                                                                        
            exit 1
        fi                                                                                                                              
fi


