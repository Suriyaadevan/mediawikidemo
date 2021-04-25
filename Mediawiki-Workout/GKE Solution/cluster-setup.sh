
#Command to Configure the GCP project in  gcloud CLI
gcloud config set project mediawiki-0415

#Enable compute service 
gcloud services enable container.googleapis.com

To Create Cluster 

gcloud container clusters create mediawiki-cluster --zone us-central1-a

#once yaml file uploaded - Please execute the below Command

kubectl apply -f mediawikisetup.yml

#Enable auto scale
kubectl autoscale deployment mediawiki-deployment --cpu-percent=50 --min=1 --max=10
#To get the external IP 

kubectl get svc

# Access the application via external IP