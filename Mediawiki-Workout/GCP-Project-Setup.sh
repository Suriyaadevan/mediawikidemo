#Project Creation(Optional If we have already project setup)
gcloud projects create mediawiki-0422 --name="mediawiki"  --labels=type=mediawik 

#Enable billing account (Optional If we have already Billing account  setup)

# Replace Billing account ID and Project ID accordingly  - --billing-account=ACCOUNT_ID

gcloud alpha billing accounts projects link mediawiki-0422  --billing-account=0X0X0X-0X0X0X-0X0X0X



