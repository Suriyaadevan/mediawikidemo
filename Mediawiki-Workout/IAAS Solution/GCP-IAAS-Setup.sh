#Command to Configure the GCP project in  gcloud CLI
gcloud config set project <Project ID>

gcloud config set project mediawiki-0422

#Enable compute service 
gcloud services enable compute.googleapis.com

#Command to get the compute service account and store it as variable
export SA_EMAIL=$(gcloud iam service-accounts list  --filter="displayName:Compute Engine default service account" --format='value(email)')

#Command to create the instance template embedded with mediawiki application setup script 
gcloud beta compute --project=$DEVSHELL_PROJECT_ID instance-templates create media-wiki-template --machine-type=e2-medium --network=projects/$DEVSHELL_PROJECT_ID/global/networks/default --network-tier=STANDARD --metadata=startup-script=\#\!\ /bin/bash$'\n'sudo\ yum\ -y\ install\ httpd\ php\ php-mysql\ php-gd\ mariadb-server\ php-xml\ php-intl\ mysql\ wget$'\n'sudo\ systemctl\ restart\ httpd.service$'\n'sudo\ systemctl\ enable\ httpd.service$'\n'sudo\ systemctl\ start\ mariadb$'\n'sudo\ systemctl\ enable\ mariadb$'\n'sudo\ wget\ https://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.2.tar.gz$'\n'sudo\ tar\ -zxpvf\ mediawiki-1.24.2.tar.gz$'\n'sudo\ mv\ mediawiki-1.24.2\ /var/www/html/mediawiki$'\n'sudo\ chown\ -R\ apache:apache\ /var/www/html/mediawiki/$'\n'sudo\ chmod\ 755\ /var/www/html/mediawiki/$'\n'sudo\ getenforce$'\n'sudo\ restorecon\ -FR\ /var/www/html/mediawiki/$'\n'echo\ \"\*\*\*\*\*\*\*\*Connecting\ MYSQL\*\*\*\*\*\*\*\*\"$'\n'mysql\ -u\ root\ -e\ \"create\ database\ mediawiki_db\"\;\ $'\n'mysql\ -u\ root\ -e\ \"CREATE\ DATABASE\ mediawiki_db\"\;\ $'\n'mysql\ -u\ root\ -e\ \"GRANT\ ALL\ PRIVILEGES\ ON\ mediawiki_db.\*\ TO\ \'wiki_user\'@\'localhost\'\ IDENTIFIED\ BY\ \'P@ssWord@123\#\'\ WITH\ GRANT\ OPTION\;\"\;\ $'\n'mysql\ -u\ root\ -e\ \"FLUSH\ PRIVILEGES\;\"\;\ $'\n'exit\; --maintenance-policy=MIGRATE --service-account=$SA_EMAIL --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=rhel-7-v20210420 --image-project=rhel-cloud --boot-disk-size=20GB --boot-disk-type=pd-balanced --boot-disk-device-name=media-wiki-template --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=mediawiki=instance-template --reservation-affinity=any


#Command to create the health-check-up
gcloud compute --project "$DEVSHELL_PROJECT_ID" health-checks create http "mediawiki-health-check" --timeout "15" --check-interval "15" --unhealthy-threshold "10" --healthy-threshold "2" --port "80" --request-path "/mediawiki/"

#command to create the Managed instance group
gcloud beta compute --project=$DEVSHELL_PROJECT_ID instance-groups managed create mediawiki-instance-group --base-instance-name=mediawiki-instance-group --template=media-wiki-template --size=1 --description="Instances used to host the MediaWiki application" --zone=us-central1-a --health-check=mediawiki-health-check --initial-delay=300

gcloud beta compute --project "$DEVSHELL_PROJECT_ID" instance-groups managed set-autoscaling "mediawiki-instance-group" --zone "us-central1-a" --cool-down-period "60" --max-num-replicas "6" --min-num-replicas "1" --target-cpu-utilization "0.6" --mode "on"


#Enable port 80 in any one of the Instances

gcloud compute firewall-rules create <Any one Instance Name> --allow tcp:80

