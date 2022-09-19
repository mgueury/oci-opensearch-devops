In this sample, you will:
  - Install OCI Devops
  - Create an automation pipeline that will use Terraform to create a VCN, subnet and compute
    - Install NGINX on that compute
    - Copy a sample website, index.html in /usr/share/nginx/html/

Step-by-Step:
- Login to the OCI cloud homepage.
- Create a notification topic. You need it to get notifications about your devops build.
  - Go to Menu - Developers Services / Applicaition Integration / Notifications
  - Click "Create Topic"
    - Name: topic-devops
    - Create
- Create a remote terraform.tfstate. You need it to have a central place to store your terraform state.
  - On your machine create a empty file. For ex with the command:
    ````
    touch terraform.tfstate
    ````
  - Go to Menu - Storage / Buckets
  - Create bucket 
    - Give a name. ex: terraform-bucket
     - Create
  - In the bucket 
    - Click "Upload"
    - Choose the terraform.tfstate
    - Click "Upload"
  - Right click on the ... at the end of the uploaded file
  - Click "Create Pre-Authenticated Request"
    - Choose an expiration date in a far future.
    - Choose "Permit object reads and writes"
    - Click "Create Pre-Authenticated Request"
    - Copy the URL: (##1##) ex: https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/xxxxxxxxxx/n/xxxxx/b/terraform-bucket/o/terraform.tfstate 
- Create a devops project
  - Go to Menu - Developers Services / DevOps / Projects
  - Click Create DevOps Project
    - Project name: oci-devops-instance-nginx
    - Select the Topic (TopicDevops)
    - Click "Create devops project"
  - In the homepage, click "Enable log". 
    - Then enable the "Enable log" Checkbox
- Create a repository
  - Click Code repositories
  - Create Repository
    - name: oci-devops-instance-nginx
    - Click "Create Repository"
  - In the create screeen, look at the documentation to create a connection with SSH to the git repository
    - Copy the line to paste in your ssh config file (##2##)
    - Copy the SSH connection to git repository (##3##)
    - In short,
      - Go on the top/right icon. Open the menu.
      - Click on your user name
      - In your user screen, scroll down. Choose API Keys
      - Click "Add API Key"
        - Download the Private Key (##4##)
        - Click "Add"
    - Start the cloud shell (icon at the top)
    ```
    mkdir .oci
    vi .oci/oci_api_key.pem
    (copy paste the private API key see ##4##)
    ...
    -----BEGIN RSA PRIVATE KEY-----
    ...
    -----END RSA PRIVATE KEY-----
    ...
    vi .ssh/config
    (see ##2##)
    ...
    Host devops.scmservice.*.oci.oraclecloud.com
      User oracleidentitycloudservice/xxx@xxxx.com@xxxx
      IdentityFile ~/.oci/oci_api_key.pem 
    ...
    cd $HOME
    git clone https://github.com/mgueury/oci-devops-instance-nginx.git
    cd oci-devops-instance-nginx
    git remote set-url origin ssh://...( see ##3## ) 
    git pull origin --allow-unrelated-histories
    (exit vi :q)
    ````
  - Edit the file compute.tf (vi or the Cloud editor)
    - Look for terraform.tfstate and replace the URL by the one created above (see ##1##)
    - ideally, you should replace the certificate id_devops_rsa and id_devops_rsa.pub
    ````
    rm id_devops_rsa id_devops_rsa.pub
    ssh-keygen -t rsa -f id_devops_rsa -N ''
    ````
    - commit the change to the git repository
    ````
    git add *
    git commit -m "tfstate url"
    git push origin
    ````
    
- Create a pipeline
  - Back to you DevOps project
  - Click "Build Pipeline" on the left
  - Create "Build Pipeline"
    - Name: pipeline
  - Click "Add a stage"
    - type "Managed Build". Next.
    - Stage Name: build
    - Primary Code repository - Click Select
      - Type oci code repository
      - Select the repositoty
      - Click 'Save'
    - Click 'Add' 
  - Go to the tab "Parameters:
    - Add:
      - Name: TF_VAR_tenancy_ocid / Value: your tenancy ex: ocid1.tenancy.oc1..aaaaaaaa4w...
      - Name: TF_VAR_compartment_ocid / Value: your compartment, ex: ocid1.compartment.oc1..aaaaaaaa...
      - Name: TF_VAR_region / Value: your region, ex: eu-frankfurt-1
- Back to the Build Pipeline tab
  - Click "Start Manual Run"
  - Click again "Start Manual Run"
- Check the output and the compute/instance console.
  - Get the IP from the end of the log of the build (or from the compute list)
  - Start the Cloud shell

````
cd oci-devops-instance-nginx
chmod 600 id_devops_rsa
ssh opc@xxx.xxx.xxx.xxx -i id_devops_rsa
curl http://localhost
<html>
<head>
 <title>DevOps</title>
</head>
<body>
  <h2>Hello from DevOps</h2>
</body>
</html>
````
