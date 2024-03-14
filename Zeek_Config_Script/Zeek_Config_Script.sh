#!/bin/bash

#declaring global variables (uses example file for testing purposes)
target_file="${PWD}/zeek_files/etc/node.cfg"
target_network="${PWD}/zeek_files/etc/networks.cfg"
i=1
ans="n"
count=1
start=true
san='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{2}'
san_2='^.*[A-Za-z]+'
san_3='^[0-9]+'
san_4='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
san_5='^[YynN]$'

#Everything is ran with in a while loop to allow the user to edit both config files during one session of the script running
while [ $start == true ];
do
    #asks user what config file they want to edit
    read -p"Do you want to define your network(s) or configure your cluster(s)? 1/2: " resp;
    echo -e "\n";

    #checks for a valid response
    while [ "$resp" != "1" ] && [ "$resp" != "2" ];do
        read -p"Please enter a valid option (1 or 2): " resp;
        if [ "$resp" == "1" ] || [ "$resp" == "2" ];
        then
            break
        fi
    done

    #if the response to the previous questions is "1" then it will run through the code for the networks.cfg file
    if [ $resp == 1 ];
    then
        #asks for a specific input. If the user's input does not match the regex it will continually ask for a new input until it matches
        read -p"How many networks would you like to add under Zeek's monitoring?: " network_num;
        while [[ $network_num =~ $san_2 ]];do
            read -p"Please enter a valid number: " network_num;
            if [[ $network_num == $san_3 ]];
            then
                break
            fi
        done
        
        read -p"what is the ip address space you want to monitor? (ex.192.168.0.0/24): " ip_space;
        while [[ ! $ip_space =~ $san ]];do
            read -p"Please enter a valid IP address (ex.192.168.0.0/24): " ip_space;
            if [[ $ip_space =~ $san ]];
            then
                break
            fi
        done

        read -p"Is this $ip_space the correct network, you would like to monitor? Y/N: " confirm;
        ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
        while [[ ! $confirm =~ $san_5 ]];do
            read -p"Please enter a valid response Y/N: " confirm;
            if [[ $confirm =~ $san_5 ]];
            then
                break
            fi
        done
        while [ "$ans" == "n" ];do
            read -p"please re-enter the correct network: " ip_space;
            while [[ ! $ip_space =~ $san ]];do
                read -p"Please enter a valid IP address (ex.192.168.0.0/24): " ip_space;
                if [[ $ip_space =~ $san ]];
                then
                    break
                fi
            done

            read -p"Is the IP space $ip_space correct? Y/N: " confirm;
            ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');

            while [[ ! $confirm =~ $san_5 ]];do
                read -p"Please enter a valid response Y/N: " confirm;
                if [[ $confirm == $san_5 ]];
                then
                    break
                fi
            done
        done
        #appends the value of ip_space to the file 
        echo -e "$ip_space" >> $target_network;

        #if the user declared they are adding more than 1 network to the file it will run throught this loop, with the same questions as previous until it has written every desired network to file
        if [ $ip_space > 1 ];
        then 
            while [ $network_num != $count ];do
                echo -e "\n";
                read -p "what is the other network you would like to monitor with Zeek? " ip_space;
                while [[ ! $ip_space =~ $san ]];do
                    read -p"Please enter a valid IP address: " ip_space;
                    if [[ $ip_space =~ $san ]];
                    then
                        break
                    fi
                done

                read -p"Is the IP space $ip_space correct? Y/N: " confirm;
                ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                while [[ ! $confirm =~ $san_5 ]];do
                    read -p"Please enter a valid response Y/N: " confirm;
                    if [[ $confirm =~ $san_5 ]];
                    then
                        break
                    fi
                done                

                while [ "$ans" == "n" ];do
                    read -p"please re-enter an IP space " ip_space;
                    while [[ ! $ip_space =~ $san ]];do
                        read -p"Please enter a valid IP address: " ip_space;
                        if [[ $ip_space =~ $san ]];
                        then
                            break
                        fi
                    done   

                    read -p"Is the IP space $ip_space correct? Y/N: " confirm;
                    ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');

                    while [[ ! $confirm =~ $san_5 ]];do
                        read -p"Please enter a valid response Y/N: " confirm;
                        if [[ $confirm =~ $san_5 ]];
                        then
                            break
                        fi
                    done                    
                done
                echo -e "$ip_space" >> $target_network;
                ((count++))
            done
        fi
        ans=$(echo "n");
    fi

    if [ $resp == 2 ];
    then 

        #asks user for ip addresses of the logger,proxy, and manager and changes the config file accordingly
        #inorder to read the users input consistently and effectively it will use the "tr" command to translate the input to lowercase and make the vaue of $ans that value using command subsitution 
        if [ $ans == "n" ];
        then
            read -p"what is the IP address of the logger? (typically server IP): " logger;
            while [[ ! $logger =~ $san_4 ]];do
                read -p"Please enter a valid IP address: " logger;
                if [[ $logger =~ $san_4 ]];
                then
                    break
                fi
            done
            read -p"Is the IP address $logger correct? Y/N: " confirm;
            ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
            while [[ ! $confirm =~ $san_5 ]];do
                read -p"Please enter a valid response Y/N:" confirm;
                if [[ $confirm =~ $san_5 ]];
                then
                    break
                fi
            done
        #If the user accidentally inputs the ip incorrectly it will give them an opportunity to change it
        #This will only run if the result of the above command subsitution is "n"
        #This will loop until $ans is equal to "y"
            while [ "$ans" == "n" ];do
                echo -e "\n";
                read -p"please re-enter the IP address: " logger;
                
                while [[ ! $logger =~ $san_4 ]];do
                    read -p"Please enter a valid IP address: " logger;
                    if [[ $logger =~ $san_4 ]];
                    then
                        break
                    fi
                done
                read -p"Is the IP address $logger correct? Y/N: " confirm;
                ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                while [[ ! $confirm =~ $san_5 ]];do
                    read -p"Please enter a valid response Y/N: " confirm;
                    if [[ $confirm =~ $san_5 ]];
                    then
                        break
                    fi
                done
            done

        #Once the script collects correct ip information using the questions above it will change the line in the config file using the sed command by taking the new value and replacing it with the old	
            logger_text="logger-ip"
            sed -i "s/$logger_text/$logger/g" "$target_file";
        fi
        #changes value of $ans and prints a newline to make it more readable
        ans=$(echo "n");
        echo -e "\n";

        #asks user for Ip of proxy
        if [ "$ans" == "n" ];
        then
            read -p"what is the IP address of the proxy? (typically server IP if you dont have one): " proxy;
            while [[ ! $proxy =~ $san_4 ]];do
                read -p"Please enter a valid IP address: " proxy;
                if [[ $proxy =~ $san_4 ]];
                then
                    break
                fi
                done            
            read -p"Is the IP $proxy correct? Y/N: " confirm;
            ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
            while [[ ! $confirm =~ $san_5 ]];do
                read -p"Please enter a valid response Y/N: " confirm;
                if [[ $confirm =~ $san_5 ]];
                then
                    break
                fi
            done
            #If the user accidentally inputs the ip incorrectly it will give them an opportunity to change it	
            while [ "$ans" == "n" ];do
                echo -e "\n";
                read -p"please re-enter the IP address: " proxy;
                while [[ ! $proxy =~ $san_4 ]];do
                    read -p"Please enter a valid IP address: " proxy;
                    if [[ $proxy =~ $san_4 ]];
                    then
                        break
                    fi
                    done                 
                read -p"Is the IP address $proxy correct? Y/N: " confirm;
                ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                while [[ ! $confirm =~ $san_5 ]];do
                    read -p"Please enter a valid response Y/N: " confirm;
                    if [[ $confirm =~ $san_5 ]];
                    then
                        break
                    fi
                done            
            done
            proxy_text="proxy-ip";
            sed -i "s/$proxy_text/$proxy/g" "$target_file";
        fi
        ans=$(echo "n");
        echo -e "\n";

        #asks user for ip of the manager
        if [ "$ans" == "n" ];
        then
            read -p"what is the IP address of the manager? (typically server IP if you dont have one): " manager;
                while [[ ! $manager =~ $san_4 ]];do
                    read -p"Please enter a valid IP address: " manager;
                    if [[ $manager =~ $san_4 ]];
                    then
                        break
                    fi
                    done             
            read -p"Is the IP address $manager correct? Y/N: " confirm;
            ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
            while [[ ! $confirm =~ $san_5 ]];do
                read -p"Please enter a valid response Y/N: " confirm;
                if [[ $confirm =~ $san_5 ]];
                then
                    break
                fi
            done
            #If the user accidentally inputs the ip incorrectly it will give them an opportunity to change it	
            while [ "$ans" == "n" ];do
                echo -e "\n";
                read -p"please re-enter the IP address: " manager;
                while [[ ! $manager =~ $san_4 ]];do
                    read -p"Please enter a valid IP address: " manager;
                    if [[ $manager =~ $san_4 ]];
                    then
                        break
                    fi
                    done 
                read -p"Is the IP address $manager correct? Y/N: " confirm;
                ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                while [[ ! $confirm =~ $san_5 ]];do
                    read -p"Please enter a valid response Y/N: " confirm;
                    if [[ $confirm =~ $san_5 ]];
                    then
                        break
                    fi
                done            
            done
        
            manager_text="manager-ip";
            sed -i "s/$manager_text/$manager/g" "$target_file";
        fi
        ans=$(echo "n");
        echo -e "\n";

        # Ask user for how many Ip addresses they are adding to the worker"
        if [ $i == 1 ];
        then
            read -p "How many workers do you want to add to your Zeek configuration file?: " ip_addresses;
            while [[ $ip_addresses =~ $san_2 ]];do
                read -p"Please enter a valid number of workers: " ip_addresses;
                if [[ $ip_addresses == $san_3 ]];
                then
                    break
                fi
            done           

            read -p"Do you want to add $ip_addresses devices as workers? Y/N: " confirm;
            ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
            while [[ ! $confirm =~ $san_5 ]];do
                read -p"Please enter a valid response Y/N: " confirm;
                if [[ $confirm =~ $san_5 ]];
                then
                    break
                fi
            done

            while [ "$ans" == "n" ];do
                echo -e "\n"
                read -p"please re-enter How many workers you want to add: " ip_addresses;
                while [[ $ip_addresses =~ $san_2 ]];do
                    read -p"Please enter a valid number of workers: " ip_addresses;
                    if [[ $ip_addresses == $san_3 ]];
                    then
                        break
                    fi
                done  

                read -p"Do you want to add $ip_addresses devices as workers? Y/N: " confirm;
                ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                while [[ ! $confirm =~ $san_5 ]];do
                    read -p"Please enter a valid response Y/N: " confirm;
                    if [[ $confirm =~ $san_5 ]];
                    then
                        ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                        break
                    fi
                done            
            done
            ((i--))
            ans=$(echo "n");
            echo -e "\n";

            #A series of questions related to the worker configurations which will be appended to config file. This will be done until the counter is equal to the number of works the user declared they wanted to add earlier
            while [ $i -lt $ip_addresses ]; do

                while [ "$ans" == "n" ]; do
                    echo -e "\n";
                    read -p"what is the IP address of worker $i?: " worker_ip;
                    while [[ ! $worker_ip =~ $san_4 ]];do
                        read -p"Please enter a valid IP address: " worker_ip;
                        if [[ $worker_ip =~ $san_4 ]];
                        then
                            break
                        fi
                    done 
                    read -p"Is the IP address $worker_ip correct? Y/N: " confirm;
                    ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                    while [[ ! $confirm =~ $san_5 ]];do
                        read -p"Please enter a valid response Y/N: " confirm;
                        if [[ $confirm =~ $san_5 ]];
                        then
                            break
                        fi
                    done                
                done
                ans=$(echo "n");
                echo -e "\n";
                
                #asks user for the interface the device is connected too
                while [ "$ans" == "n" ]; do
                    echo -e "\n";
                    read -p"what interface can the server communicate with it?(ie. eth0, ens33, lo): " worker_interface;
                    read -p"Is the IP address $worker_ip correct? Y/N: " confirm;
                    ans=$(echo "$confirm" | tr '[:upper:]' '[:lower:]');
                    while [[ ! $confirm =~ $san_5 ]];do
                        read -p"Please enter a valid response Y/N: " confirm;
                        if [[ $confirm =~ $san_5 ]];
                        then
                            break
                        fi
                    done                
                done
                ans=$(echo "n");

                #adds the information of the worker to the config file using the required format
                echo -e "[worker-$i]\ntype=worker\nhost=$worker_ip\ninterface=$worker_interface\n#" >> $target_file;
                ((i++))
            done
        fi
    fi
    
    #Asks user if they want to go back tot he menu inorder to select another config file to edit
    echo -e "\nYou're all set!!!\nYour config file(s) should now be properly configured for your Zeek adventures to begin!!!"
    read -p"do you want to go back to the menu? Y/N: " menu;
    while [[ ! $menu =~ $san_5 ]];do
        read -p"Please enter a valid response Y/N: " menu;
        if [[ $menu =~ $san_5 ]];
        then
            break
        fi
    done    

    if [ "$menu" == "n" ] || [ "$menu" == "N" ];
    then 
        start=$(echo false);
        echo -e "\nThanks for using the Zeek Config File Editor 3000!!!";    
    fi
    echo -e "\n";
done
