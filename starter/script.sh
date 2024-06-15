#!/bin/bash
#
# Automation script for CloudFormation templates.
#
# Parameters
#   TARGET_TEMPLATE:        CloudFormation templates to use. Valid values: Network, Application.
#   TEMPLATE_FILE_NAME:     Name of the template file. Determined by TARGET_TEMPLATE value.
#   PARAMETERS_FILE_NAME:   Name of the parameters file. Determined by TARGET_TEMPLATE value.
#   EXECUTION_MODE:         Execution mode. Valid values: Deploy, Delete, Preview.
#   REGION:                 Target AWS region. User text input.
#   STACK_NAME:             Name of the cloudformation stack. User text input.
#
# Usage examples:
#   Target template: Network (network.yml, network-parameters.json)
#   Execution mode: Deploy
#   Region: us-east-1
#   Stack name: cloudformation-project
#
#   Target template: Application (udagram.yml, udagram-parameters.json)
#   Execution mode: Delete
#   Region: us-east-1
#   Stack name: cloudformation-project
#

# Declare Bash text colours
BLUE=$'\e[0;34m'
CYAN=$'\e[0;36m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m' # No colour

# Function to prompt the user to select from a list of options
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    
    while true; do
        echo -e "$prompt"
        PS3="$NC"
        select opt in "${options[@]}"; do
            if [[ -n "$opt" ]]; then
                echo "$opt"
                return
            fi
        done
        
    done
}

# Function to prompt user to confirm if they wish to proceed with applying CloudFormation
confirm_proceed() {
    while true; do
        read -p "${YELLOW}Proceed? (Y/N):${NC} " answer
        case "$answer" in
            [Yy]*)
                echo -e "Yes selected, applying CloudFormation template..."
                break
                ;;
            [Nn]*)
                echo -e "No selected, aborting script...\n"
                exit 0
                ;;
            *)
                echo -e "Invalid input. Please enter Yes or No.\n"
                ;;
        esac
    done
}

# Ask the user to select TARGET_TEMPLATE
echo -e "${YELLOW}Select the template to use:"
TARGET_TEMPLATE=$(select_option "" "Network" "Application")

# Set TEMPLATE_FILE_NAME and PARAMETERS_FILE_NAME
if [ $TARGET_TEMPLATE = "Network" ]; then
    TEMPLATE_FILE_NAME="network.yml"
    PARAMETERS_FILE_NAME="network-parameters.json"
elif [ $TARGET_TEMPLATE = "Application" ]; then
    TEMPLATE_FILE_NAME="udagram.yml"
    PARAMETERS_FILE_NAME="udagram-parameters.json"
fi

# Ask the user to select EXECUTION_MODE
echo -e "\n${YELLOW}Select the execution mode:"
EXECUTION_MODE=$(select_option "" "Deploy" "Delete" "Preview")

# Ask the user for REGION input
echo -e "\n${YELLOW}Input the region to deploy to, e.g. us-east-1, us-west-1:"
read -p "${NC}" REGION

# Ask the user for STACK_NAME input
echo -e "\n${YELLOW}Input name of the CloudFormation stack:"
read -p "${NC}" STACK_NAME

# Display the selected options
echo -e ""
echo -e "${YELLOW}Please review your selected options and confirm if you would like to proceed."
echo -e "${BLUE}Target template:"${CYAN}$TARGET_TEMPLATE" ($TEMPLATE_FILE_NAME, $PARAMETERS_FILE_NAME)"
echo -e "${BLUE}Execution mode:"${CYAN}$EXECUTION_MODE
echo -e "${BLUE}Region:" ${CYAN}$REGION
echo -e "${BLUE}Stack name:" ${CYAN}$STACK_NAME
echo -e ""

# Ask the user if they wish to proceed with applying CloudFormation
confirm_proceed

# Execute CloudFormation CLI
if [ $EXECUTION_MODE == "Deploy" ]; then
    aws cloudformation deploy \
        --stack-name $STACK_NAME \
        --template-file $TEMPLATE_FILE_NAME \
        --parameter-overrides file://$PARAMETERS_FILE_NAME \
        --capabilities CAPABILITY_NAMED_IAM  \
        --region=$REGION
elif [ $EXECUTION_MODE == "Delete" ]; then
    aws cloudformation delete-stack \
        --stack-name $STACK_NAME \
        --region=$REGION
elif [ $EXECUTION_MODE == "Preview" ]; then
    aws cloudformation deploy \
        --stack-name $STACK_NAME \
        --template-file $TEMPLATE_FILE_NAME \
        --parameter-overrides file://$PARAMETERS_FILE_NAME \
        --capabilities CAPABILITY_NAMED_IAM  \
        --no-execute-changeset \
        --region=$REGION 
fi
