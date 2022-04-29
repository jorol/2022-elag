# Exercises

Download files:

```bash
$ wget https://jorol.github.io/2022-elag/files/processing-marc.zip
$ unzip processing-marc.zip
$ cd processing-marc
```

## MARC 21 documentation

Check the [MARC 21 documenation](https://www.loc.gov/marc/bibliographic/) of the following fields:

* 007
* 020
* 082
* 100
* 245
* 700

Are data elements positionally defined? Are codes used within fields? Are fields or subfields repeatable?

## MARC 21 serializations

Look at the different MARC serialization of the "Code4lib" record (`code4lib.*`), e.g.:

```bash
# on the command-line
$ less code4lib.mrk
# press `q` to quit command

# with a text editor like geany
$ geany code4lib.xml
```

## Documentation of software tools

Check the documentation of the recommended tools:

```bash
$ catmandu --help
$ catmandu info
$ marcvalidate --help
$ marcstats.pl --help
# press `q` to quit `man` pages
$ man uconv
$ man yaz-client
$ man yaz-marcdump
$ man xmllint
$ man xsltproc
```

## Download MARC data


### ... from a Z39.50 server with `yaz-client`

Replace the variable `{SUBJECT}` with a subject term of your choice.

See [ATTRIBUTE SET BIB-1 (Z39.50-1995)](https://www.loc.gov/z3950/agency/bib1.html) for other attribute values.

```bash
# open client
$ yaz-client
# connect to database
Z> open lx2.loc.gov/LCDB
# set format to MARC
Z> format 1.2.840.10003.5.10
# set element set
Z> element F
# append retrieved records to file
Z> set_marcdump elag.z3950.mrc
# find record for subject
Z> find @attr 5=100 @attr 1=21 "{SUBJECT}"
# get first 50 records
Z> show 1+50
# close client
Z> exit
```

### ... from a SRU server with `catmandu`


Replace the variable `{TITLE}` with a journal title of your choice.

See [SRU explain](http://services.dnb.de/sru/zdb?operation=explain&version=1.1) for other supported indices.

```bash
$ catmandu convert -v SRU \
--base https://services.dnb.de/sru/zdb \
--recordSchema MARC21-xml \
--query 'dnb.tit = {TITLE}' \
--parser marcxml \
to MARC --type XML > elag.sru.xml
```

## Validate your data

### ... with `yaz-marcdump`

```bash
$ yaz-marcdump -n elag.z3950.mrc
$ yaz-marcdump -n -i marcxml elag.sru.xml
```

### ... with `xmllint`

```bash
$ xmllint --noout \
--schema http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd \
elag.sru.xml
```

### ... with `marcvalidate`

```bash
$ marcvalidate elag.z3950.mrc
$ marcvalidate --type XML elag.sru.xml
```

## Create statistics for your data

### ... with `marcstats.pl`

```bash
$ marcstats.pl elag.z3950.mrc
# replace spaces with dots & save result in file
$ marcstats.pl --dots -o elag.z3950.stats.txt elag.z3950.mrc
```

### ... with `catmandu`

```bash
# "break" MARC record in pieces
$ catmandu convert MARC --type XML to Breaker --handler marc \
< elag.sru.xml > elag.sru.breaker
# generate statistic
$ catmandu breaker elag.sru.breaker
# save statistic as XLSX file
$ catmandu breaker --as XLSX elag.sru.breaker > elag.sru.xlsx
$ soffice elag.sru.xlsx
```

## Unicode normalization


```bash
# get some data in Unicode normalization form NFD
# pretty print with xmllint
$ catmandu convert -v SRU \
--base https://services.dnb.de/sru/zdb \
--recordSchema MARC21-xml \
--query 'dnb.zdbid = 242095-8' \
--parser marcxml to MARC --type XML \
| xmllint --pretty 1 - > elag.nfd.xml
# convert to Unicode normalization form NFC
$ uconv -x NFC elag.nfd.xml > elag.nfc.xml
# show difference between files. only lines with umlauts are marked. 
$ diff elag.nfc.xml elag.nfd.xml
```

## Transform different MARC serializations

### ... with `yaz-marcdump`

```bash
# MARC (ISO 2709) to MARC Line
$ yaz-marcdump -o line elag.z3950.mrc
# MARC XML to Turbomarc
$ yaz-marcdump -i marcxml -o turbomarc elag.sru.xml
```

### ... with `catmandu`

```bash
# MARC (ISO 2709) to MARC-in-JSON
$ catmandu convert MARC to MARC --type MiJ < elag.z3950.mrc
# MARC XML to MARCMaker
$ catmandu convert MARC --type XML to MARC --type MARCMaker < elag.sru.xml
# MARC to Breaker
$ catmandu convert MARC --type XML to Breaker --handler marc < elag.sru.xml 
# MARC to CSV. mapping with fixes required.
$ catmandu convert MARC --type XML to TSV --fix 'marc_map(022a,bibo_issn,join:";");marc_map(245abc,dc_title,join:" ");remove_field(record)' < elag.sru.xml
```

### ... with `xlstproc`

```bash
# MARC XML to MODS
$ xsltproc MARC21slim2MODS3-7.xsl elag.sru.xml
# MARC XML to RFD-DC
$ xsltproc MARC21slim2RDFDC.xsl elag.sru.xml
# MARC XML to BIBFRAME
$ xsltproc bibframe-xsl/marc2bibframe2.xsl elag.sru.xml
```

## Extract data from MARC records

### ... with `xmllint`

Get a list of all MARC tags:

```bash
$ xmllint --xpath '//@tag' elag.sru.xml | sort | uniq -c
```

Get all IDs from MARC 001:

```bash
$ xmllint --xpath '//*[local-name()="controlfield"][@*[local-name()="tag" and .="001"]]/text()' elag.sru.xml
```

Get all MARC 245 subfields:

```bash
$ xmllint --xpath '//*[local-name()="datafield"][@*[local-name()="tag" and .="245"]]' elag.sru.xml
```

Get title from MARC 245$a:

```bash
$ xmllint --xpath '//*[local-name()="datafield"][@*[local-name()="tag" and .="245"]]/*[local-name()="subfield"][@*[local-name()="code" and .="a"]]/text()' elag.sru.xml
```

Get all ISSN from MARC 022$a:

```bash
$ xmllint --xpath '//*[local-name()="datafield"][@*[local-name()="tag" and .="022"]]/*[local-name()="subfield"][@*[local-name()="code" and .="a"]]/text()' elag.sru.xml
```

Extract all DDC numbers from MARC 082$a:

```bash
$ xmllint --xpath '//*[local-name()="datafield"][@*[local-name()="tag" and .="082"]]/*[local-name()="subfield"][@*[local-name()="code" and .="a"]]/text()' elag.sru.xml
```

### ... with `catmandu`

Use `Catmandu::Breaker` in combination unix utilities like `grep`, `cut`, `sort` and `uniq`:

```bash
# check the Breaker output format
$ catmandu convert MARC --type XML to Breaker --handler marc < elag.sru.xml
# get all ISSNs from MARC 022$a
$ catmandu convert MARC --type XML to Breaker --handler marc < elag.sru.xml | \
grep -P '\t022a\t' | cut -f 3 | sort
# get all uniq DDC form MARC 082$a
$ catmandu convert MARC --type XML to Breaker --handler marc < elag.sru.xml | \
grep -P '\t082a\t' | cut -f 3 | sort | uniq -c 
```

Use the `MARCMaker` format in combination with `grep`:

```bash
# get all MARC 022 fields
$ catmandu convert MARC --type XML to MARC --type MARCMaker < elag.sru.xml | \
grep -P '^=022'
# get all MARC 245 fields with indicators 0  
$ catmandu convert MARC --type XML to MARC --type MARCMaker  < elag.sru.xml | \
grep -P '^=245  00'
```

Use fix `marc_map` to extract and map data from MARC records:

```bash
$ catmandu convert MARC --type XML to TSV \
--fix 'marc_map(001,dc_identifier);marc_map(022a,bibo_issn,join:",");marc_map(245a,dc_title);remove_field(record)' \
< elag.sru.xml
```

Extract the language code from MARC 008 and lookup the language:

```bash
$ catmandu convert MARC --type XML to TSV \
--fix 'marc_map(008/35-37,dc_language);lookup(dc_language,dict_languages.csv,delete:1);remove_field(record)' \
< elag.sru.xml
```

Extract fields with specific indicators:

```bash
$ catmandu convert MARC --type XML to TSV \
--fix 'marc_map("246[1,4]",marc_varyingFormOfTitle);remove_field(record)' \
--fields _id,marc_varyingFormOfTitle \
< loc.mrc.xml
```

Extract several subfields with certain codes:

```bash
# as string
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(245ab,dc_title,join:" ");remove_field(record)' \
< loc.mrc.xml
# as array
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(245ab,dc_title,split:1);remove_field(record)' \
< loc.mrc.xml
# as array in certain order
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(245ba,dc_title,split:1,pluck:1);remove_field(record)' \
< loc.mrc.xml
```

Extract data from repeatable fields:

```bash
# create an array for subjects
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(650a,dc_subject,split:1);remove_field(record)' \
< loc.mrc.xml
```

Extract data from repeatable fields with repeatable subfields:

```bash
# create one array for index terms
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(655ay,marc_indexTermGenre,split:1);remove_field(record)' \
< loc.mrc.xml
# create an array of arrays for index terms, one array for each MARC field.
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(655ay,marc_indexTermGenre,split:1,nested_arrays:1);remove_field(record)' \
< loc.mrc.xml
```

Extract subfields depending on another subfield value:

```bash
$ catmandu convert MARC --type XML to JSON --pretty 1 \
--fix '
do marc_each()
  if marc_match(856x,EZB)
    marc_map(856u,ezb_uri)
  end
end;
remove_field(record)' \
< code4lib.xml
```

Assign a new value to (sub)fields:

```bash
$ catmandu convert MARC --type XML to MARC --type MARCMaker \
--fix 'marc_set(001,123456789);marc_set(245a,"My Title");marc_set(245b," ... added by fix.")' \
< elag.sru.xml
```

Remove (sub)fields from records:

```bash
$ catmandu convert MARC --type XML to MARC --type MARCMaker \
--fix 'marc_remove(003);marc_remove(6..);marc_remove(856xz);' \
< elag.sru.xml
```

Add a new MARC 999 field to all records:

Create a UUID with fix `uuid` and add it as subfield $b to the new MARC field. 

```bash
$ catmandu convert MARC --type XML to MARC --type MARCMaker \
--fix 'uuid(uuid);marc_add(999,a,"Local UUID",b,$.uuid)' \
< elag.sru.xml
```

Replace strings in (sub)fields:

```bash
$ catmandu convert MARC --type XML to MARC --type MARCMaker \
--fix 'marc_replace_all(856u,"^http://","https://")' \
< elag.sru.xml
```

Filter MARC records:

```bash
$ catmandu convert -v MARC --type XML to MARC --type MARCMaker \
< loc.mrc.xml
$ catmandu convert -v MARC --type XML to MARC --type MARCMaker \
--fix 'select marc_match(245a,Perl)' \
< loc.mrc.xml
```

Validate MARC records:

```bash
# catch errors
$ catmandu convert -v MARC --type XML to JSON --pretty 1 \
--fix 'validate(.,MARC,error_field: errors);remove_field(record)' \
< loc.mrc.xml
# filter valid records
$ catmandu convert -v MARC --type XML to MARC --type MARCMaker \
--fix 'select valid(.,MARC)' \
< loc.mrc.xml
```

Extract and normalize IBSNs, keep only uniques:

```bash
$ catmandu convert -v MARC --type XML to JSON --pretty 1 \
--fix 'marc_map(020a,bibo_isbn,split:1); replace_all(bibo_isbn.*,"\s.*$","");isbn13(bibo_isbn.*);uniq(bibo_isbn);remove_field(record);' \
< loc.mrc.xml
```