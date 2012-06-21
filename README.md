Sample app to illustrate connecting log4r logging to graylog using the complete_passenger_postgresql+resque rubber templates
To deploy it yourself, create the file config/rubber/rubber-secret.yml with contents similar to the following (See the [rubber wiki](https://github.com/wr0ngway/rubber/wiki/Quick-Start) for more configuration details):

    cloud_providers:
      aws:
        access_key: "your_ec2_access_key"
        secret_access_key: "your_ec2_secret_access_key"
        account: Your_ec2_account_number_no_punctuation
        key_name: your_ec2_keypair_name
        key_file: "/path/to/your_ec2_keypair.pem"
    
    web_tools_user: admin
    web_tools_password: sekret
