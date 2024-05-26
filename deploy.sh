# debug
# set -o xtrace

KEY_NAME="parking-lot-`date +'%N'`"
KEY_PEM="$KEY_NAME.pem"

echo "create key pair $KEY_PEM to connect to instances and save locally"
aws ec2 create-key-pair --key-name $KEY_NAME \
    | jq -r ".KeyMaterial" > $KEY_PEM

# secure the key pair
chmod 400 $KEY_PEM

SEC_GRP="my-sg-`date +'%N'`"

echo "setup firewall $SEC_GRP"
aws ec2 create-security-group   \
    --group-name $SEC_GRP       \
    --description "Access my instances" 

# figure out my ip
MY_IP=$(curl ipinfo.io/ip)
echo "My IP: $MY_IP"

# setting up security group and allowing the key access to my IP only
echo "setup rule allowing SSH access to $MY_IP only"
aws ec2 authorize-security-group-ingress        \
    --group-name $SEC_GRP --port 22 --protocol tcp \
    --cidr $MY_IP/32

echo "setup rule allowing HTTP (port 5000) access to $MY_IP only"
aws ec2 authorize-security-group-ingress        \
    --group-name $SEC_GRP --port 5000 --protocol tcp \
    --cidr 0.0.0.0/0

# change to amazom-linux
AMAZON_LINUX_2024="ami-01f10c2d6bce70d90"


# creating instance -  change echo command
echo "Creating Ubuntu 20.04 instance..."
RUN_INSTANCES=$(aws ec2 run-instances   \
    --image-id $AMAZON_LINUX_2024        \
    --instance-type t2.micro            \
    --key-name $KEY_NAME                \
    --security-groups $SEC_GRP)

INSTANCE_ID=$(echo $RUN_INSTANCES | jq -r '.Instances[0].InstanceId')

echo "Waiting for instance creation..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

PUBLIC_IP=$(aws ec2 describe-instances  --instance-ids $INSTANCE_ID | 
    jq -r '.Reservations[0].Instances[0].PublicIpAddress'
)

echo "New instance $INSTANCE_ID @ $PUBLIC_IP"
# to change
echo "deploying code to production"
scp -i $KEY_PEM -o "StrictHostKeyChecking=no" -o "ConnectionAttempts=60" deploy.sh ec2-user@$PUBLIC_IP:/home/ec2-user

echo "setup production environment"
ssh -i $KEY_PEM -o "StrictHostKeyChecking=no" -o "ConnectionAttempts=10" ec2-user@$PUBLIC_IP <<EOF
    sudo apt update
    sudo apt install -y openjdk-17-jdk maven git
    
    # Clone the repository (assuming the code is in a Git repository)
    git clone https://github.com/tamaralmogy/Parking-Lot /home/ec2-user/parkinglot
    cd /home/ec2-user/parkinglot

    # Build the project
    mvn clean package

    # Run the application
    nohup java -jar target/parkinglot-0.0.1-SNAPSHOT.jar &
    exit
EOF

echo "test that it all worked"
curl  --retry-connrefused --retry 10 --retry-delay 1  http://$PUBLIC_IP:5000