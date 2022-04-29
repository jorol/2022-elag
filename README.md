# ELAG 2022 boot camp "Processing MARC … with open source tools"

In 2002 Roy Tennant declared ["MARC Must Die"](http://soiscompsfall2007.pbworks.com/f/marc+must+die.pdf). Today the [MARC 21 format](https://www.loc.gov/marc/) is still the workhorse of library metadata. Even our "Next Generation Library Systems" heavily rely on this standard from the ‘60s. This boot camp will give an introduction to this arcane standard. Topics will be:

* Structure of MARC 21 records and their different serializations (MARC, MARCXML, MARCMaker, ALEPSEQ, ...)

* Validation of MARC 21 records and common errors

* Statistic analysis of MARC 21 data sets 

* Conversion of MARC 21 records

* Metadata extraction from MARC 21 records

## Requirements

This bootcamp is aimed at systems librarians, metadata librarians and data managers. For most of the tasks we will use command line tools like `catmandu`, `marcvalidate`, `yaz-marcdump` and `xmllint`, so participants should be familiar with command line interfaces (CLI) and have a basic knowledge of library metadata. For exercises a notebook is required. You could use a [VirtualBox](https://www.virtualbox.org/wiki/Downloads) image with preinstalled tools (see [VM](VM.md)) or install all tools by yourself (see [Software](Software.md)). Participants could bring their own MARC 21 datasets to work with.

## Literature

- Avram (1975): *MARC; its History and implications.* <http://catalog.hathitrust.org/Record/002993527>
- Eversberg (1999): *Was sind und was sollen Bibliothekarische Datenformate* [urn:nbn:de:gbv:084-1103231323](https://nbn-resolving.org/urn%3Anbn%3Ade%3Agbv%3A084-11032313237)
- Tennant (2002): *MARC Must Die.* <https://www.libraryjournal.com/?detailStory=marc-must-die>
- Karen Smith-Yoshimura, Catherine Argus, Timothy J. Dickey, Chew Chiat Naun, Lisa Rowlinson de Oritz & Hugh Taylor (2010): *Implications of MARC Tag Usage on Library Metadata Practices* <https://www.oclc.org/content/dam/research/publications/library/2010/2010-06.pdf>
- Tennant (2013-2018): *MARC Usage in WorldCat* <http://roytennant.com/proto/groundtruthing/>
- Király (2019): *Validating 126 million MARC records* [10.1145/3322905.3322929](https://doi.org/10.1145/3322905.3322929)
- Király (2019): *Measuring Metadata Quality* [10.13140/RG.2.2.33177.77920](https://doi.org/10.13140/RG.2.2.33177.77920)

## Links

- [Avram schema for MARC 21](https://pkiraly.github.io/2018/01/28/marc21-in-json/)
- [Catmandu::MARC::Tutorial](https://metacpan.org/dist/Catmandu-MARC/view/lib/Catmandu/MARC/Tutorial.pod)
- [MARC Standards](https://www.loc.gov/marc/)
- [MARC 21 format for Bibliographic Data](https://www.loc.gov/marc/bibliographic/)
- [Tutorial "Processing MARC ... with open source tools"](https://jorol.github.io/processing-marc/#/)
