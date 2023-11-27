#!/bin/bash

# Function to process files in the current directory
process_files() {
    # Execute ls -l for the current directory and process each line
    ls -l | while IFS= read -r line; do
        # Retrieve the second field (column) of the line
        second_column=$(echo "$line" | awk '{print $2}')

        # Check if the second column is equal to 1
        if [ "$second_column" -eq 1 ]; then
            # Use awk to print from the ninth field to the end of the line and remove leading/trailing spaces
            file_name=$(echo "$line" | awk '{for(i=9; i<=NF; ++i) printf "%s ", $i; print ""}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

            # Check that the file does not have the extension .nfo, .sh, .log, .rar, .png, or .jpg
            if [[ "$file_name" != *.nfo && "$file_name" != *.sh && "$file_name" != *.log && "$file_name" != *.rar && "$file_name" != *.png && "$file_name" != *.jpg && "$file_name" != *.html && "$file_name" != *.txt && "$file_name" != *.url && "$file_name" != *.URL && "$file_name" != *.rtf ]]; then
                # Uncomment the line below to remove the file
                rm_output=$(rm "$file_name" 2>&1)

                # Check the exit status of rm
                if [ $? -eq 0 ]; then
                    # If successful, display a message
                    echo "The file \"$file_name\" was deleted successfully."
                else
                    # If unsuccessful, display an error message in red
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
    if [ -d "$dir" ]; then
        # Enter the subdirectory
        cd "$dir"

        # Execute the function recursively
        process_files

        # Return to the parent directory
        cd ..
    fi
done