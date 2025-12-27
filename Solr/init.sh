#!/bin/bash

echo "Initialazing Solr Schemas creation"


curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"ATC",
     "type":"string",
     "indexed":false,
     "stored":true},
  "add-field":{
     "name":"ATC_level",
     "type":"pint",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"chebi_id",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"cid",
     "type":"pint",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"cross_references",
     "type":"string",
     "indexed":false,
     "stored":true,
     "multiValued":true},
  "add-field":{
     "name":"inchikey",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"mesh_headings",
     "type":"text_general",
     "indexed":true,
     "stored":true },
  "add-field":{
     "name":"mesh_id",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"semantic_type",
     "type":"text_general",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"synonyms",
     "type":"text_general",
     "indexed":true,
     "stored":true,
     "multiValued":true },
  "add-field":{
     "name":"term",
     "type":"text_general",
     "indexed":true,
     "stored":true },
}' http://localhost:8983/solr/bioner-drugs/schema


curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"uniprot_id",
     "type":"string",
     "indexed":false,
     "stored":true,
     "multiValued":true },
  "add-field":{
     "name":"ncbi_gene_id",
     "type":"pint",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"cross_references",
     "type":"string",
     "indexed":false,
     "stored":true,
     "multiValued":true},
  "add-field":{
     "name":"ncbi_taxon_id",
     "type":"pint",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"type",
     "type":"text_general",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"synonyms",
     "type":"text_general",
     "indexed":true,
     "stored":true,
     "multiValued":true },
  "add-field":{
     "name":"term",
     "type":"text_general",
     "indexed":true,
     "stored":true },
}' http://localhost:8983/solr/bioner-genetic/schema


curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"mesh_id",
     "type":"string",
     "indexed":false,
     "stored":true},
  "add-field":{
     "name":"cui",
     "type":"string",
     "indexed":false,
     "stored":true,
     "multiValued":true },
  "add-field":{
     "name":"cross_references",
     "type":"string",
     "indexed":false,
     "stored":true,
     "multiValued":true},
  "add-field":{
     "name":"ICD10_id",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"semantic_type",
     "type":"text_general",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"synonyms",
     "type":"text_general",
     "indexed":true,
     "stored":true,
     "multiValued":true },
  "add-field":{
     "name":"term",
     "type":"text_general",
     "indexed":true,
     "stored":true },
}' http://localhost:8983/solr/bioner-diseases/schema

curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"association_score",
     "type":"pfloat",
     "indexed":false,
     "stored":true},
  "add-field":{
     "name":"evidence_url",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"target_url",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"ebi_reference",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"PR_id",
     "type":"string",
     "indexed":false,
     "stored":true },
  "add-field":{
     "name":"term",
     "type":"text_general",
     "indexed":true,
     "stored":true },
}' http://localhost:8983/solr/bioner-covid/schema


echo "Schemas created!!!"


echo "Initialazing Solr Indexing"

curl 'http://localhost:8983/solr/bioner-diseases/update/json?commit=true' --data-binary @data_processing/data/Disease/diseases.json -H 'Content-type:application/json'

echo "Disease Indexing finished!!"

curl 'http://localhost:8983/solr/bioner-drugs/update/json?commit=true' --data-binary @data_processing/data/Chemical/drugs.json -H 'Content-type:application/json'

echo "Chemical Indexing finished!!"

curl 'http://localhost:8983/solr/bioner-genetic/update/json?commit=true' --data-binary @data_processing/data/Genetic/genetic.json -H 'Content-type:application/json'

echo "Genetic Indexing finished!!"

curl 'http://localhost:8983/solr/bioner-covid/update/json?commit=true' --data-binary @data_processing/data/COVID/covid.json -H 'Content-type:application/json'

echo "COVID Indexing finished!!"
echo "Indexing Finished!!!"
