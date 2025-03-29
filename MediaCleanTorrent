#!/bin/bash

qb_auth() {
    local login=$(curl -i --header 'Referer: http://192.168.1.47:10095' --data 'username=admin&password=adminadmin' http://192.168.1.47:10095/api/v2/auth/login)
    cookie=$(echo "$login" | awk 'NR==9 {print $2}' | sed 's/.$//')
    echo "$cookie"
}

# Function to get the list of torrents in downloading state
get_torrent_downloading_list() {
    local response

    response=$(curl 'http://192.168.1.47:10095/api/v2/torrents/info?filter=downloading&filter=active' --cookie "$(qb_auth)")
    format=$(echo "$response" | jq -r '.[] | [.name] | @tsv')
    echo "$format"
}

downloading=$(get_torrent_downloading_list)

# Function to process files in the current directory
process_files() {
    ls -l | while IFS= read -r line; do
        second_column=$(echo "$line" | awk '{print $2}')
        if [ "$second_column" -eq 1 ]; then
            file_name=$(echo "$line" | awk '{for(i=9; i<=NF; ++i) printf "%s ", $i; print ""}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [[ "$downloading" == *"$file_name"* ]]; then
                echo -e "\e[34mFile \"$file_name\" is in the downloading list, skipping...\e[0m"
                exit=1
            fi
            if [[ "$file_name" != *.nfo && "$file_name" != *.sh && "$file_name" != *.log && "$file_name" != *.rar && "$file_name" != *.png && "$file_name" != *.jpg && "$file_name" != *.html && "$f>
                rm_output=$(rm "$file_name" 2>&1)
                if [ $? -eq 0 ]; then
                    echo -e "\e[32mThe file \"$file_name\" was deleted successfully.\e[0m"
                else
                    echo -e "\e[31mError deleting the file \"$file_name\". $rm_output\e[0m"
                fi
            fi
        fi
    done
}

# Execute the function in the current directory
process_files

# Iterate over subdirectories and execute the function recursively
for dir in */; do
    direxit=0
    dirname=$(echo "$dir" | sed 's/.$//')
    if [[ "$downloading" == *"$dirname"* ]]; then
        direxit=1
        echo -e "\e[34mDirectory \"$dirname\" is in the downloading list, skipping...\e[0m"
    fi
    if [[ -d "$dir" && "$direxit" != 1 ]]; then
        cd "$dir"
        process_files
        cd ..
    fi
done
