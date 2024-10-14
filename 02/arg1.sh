#!/bin/bash

# Initialize variables to track options
input_file=""
output_file=""
options=""

# Function to display the list of options
print_options() {
    echo "$options" | sort
}

# Process options using getopts
while getopts ":abcri:o:q" opt; do
    case $opt in
        a|b|c|r)
            options+="-${opt} present"
            ;;
        i)
            if [ -z "$OPTARG" ]; then
                echo "-i -o options require a filename"
                exit 1
            fi
            input_file=$OPTARG
            options+="-i present and set to \"$OPTARG\""
            ;;
        o)
            if [ -z "$OPTARG" ]; then
                echo "-i -o options require a filename"
                exit 1
            fi
            output_file=$OPTARG
            options+="-o present and set to \"$OPTARG\""
            ;;
        q)
            echo "Unsupported option: -q"
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Remove processed options from arguments
shift $((OPTIND - 1))

# Print sorted options
print_options

# Print arguments, if any
if [ "$#" -gt 0 ]; then
    echo "Arguments are:"
    i=1
    for arg in "$@"; do
        echo "\$$i=$arg"
        i=$((i+1))
    done
fi
