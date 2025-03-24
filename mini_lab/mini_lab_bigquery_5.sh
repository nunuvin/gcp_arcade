#!/usr/bin/bash

#in theory should run
DATASET=customer_details
TABLE=customers
NEWTABLE=male_customers
BUCKET="gs://BUCKET" #PUT YOUR BUCKET HERE

bq load --autodetect --source_format=CSV $DATASET.$TABLE customers.csv

bq query --use_legacy_sql=false --destination_table=$DATASET.$NEWTABLE 'SELECT CustomerID, Gender, Age, `Annual Income`, `Spending Score` FROM ${DATASET}.${TABLE} WHERE Gender = "Male"'

bq query --format=csv --use_legacy_sql=false 'SELECT * FROM ${DATASET}.${NEWTABLE}' > exported_$NEWTABLE.csv

; bq extract --destination_format CSV $DATASET.$NEWTABLE $BUCKET/exported_$NEWTABLE.csv

gsutil cp exported_$NEWTABLE.csv $BUCKET/
