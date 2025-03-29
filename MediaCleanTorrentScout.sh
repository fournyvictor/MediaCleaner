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
                echo -e "\e[34mFile \"$processed_line\" is in the downloading list, skipping...\e[0m"
                exit=1
            fi
            if [[ "$file_name" != *.nfo && "$file_name" != *.sh && "$file_name" != *.log && "$file_name" != *.rar && "$file_name" != *.png && "$file_name" != *.jpg && "$file_name" != *.html && "$f>
                rm_output=$(echo "$file_name" 2>&1)
                if [ $? -eq 0 ]; then
                    echo -e "\e[32mThe file \"$file_name\" would be deleted.\e[0m"
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

# Replace 'WEBHOOK_URL' with your Discord webhook URL
WEBHOOK_URL=""

# Replace 'LOG_FILE_PATH' with the full path to your log file
LOG_FILE_PATH="/mnt/Stockage/Jelly/MediaCleanScout.log"
 while IFS= read -r line; do
        processed_line=$(echo "$line" | cut -c6- | rev | cut -c5- | rev)
        log_content="$log_content$processed_line\n"
    done < "$LOG_FILE_PATH"

# Check if the log file exists
if [ -f "$LOG_FILE_PATH" ]; then
    # Send the log file to the Discord webhook
    curl -X POST -H "Content-Type: multipart/form-data" -F "file=@$LOG_FILE_PATH" "$WEBHOOK_URL"
    echo "Log file sent successfully."
else
    echo "The log file does not exist: $LOG_FILE_PATH"
fi

    
