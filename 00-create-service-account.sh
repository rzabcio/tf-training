#!/bin/bash

USER_NAME=terraform
KEY_FILE=sa-$USER_NAME-key.json

project=$(gcloud config get-value project 2> /dev/null)
sa_email=$(gcloud iam service-accounts list --format="value(email)" | grep $USER_NAME)
if [ -z $terraform_user ]; then
	echo "+++ user needs to be created"
	gcloud iam service-accounts create terraform
	sa_email=$(gcloud iam service-accounts list --format="value(email)" | grep $USER_NAME)
else
	echo "    user exists"
fi
gcloud projects add-iam-policy-binding $project --member=serviceAccount:$sa_email --role=roles/owner

if [ ! -f $KEY_FILE ]; then
	gcloud iam service-accounts keys create $KEY_FILE --iam-account=$sa_email
fi


