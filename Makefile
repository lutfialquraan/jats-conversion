#TMPDIR := $(shell mktemp -d)
#trap "rm -rf $TMPDIR" EXIT

.PHONY: fetch

fetch: | jats crossref nlm-stylechecker datacite doaj eutils nlm w3

# Archive files

downloads:
	mkdir -p downloads

downloads/jats-publishing-dtd-1.0.zip: | downloads
	wget -c -P downloads ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/jats-publishing-dtd-1.0.zip

downloads/journal-publishing-dtd-3.0.zip: | downloads
	wget -c -P downloads ftp://ftp.ncbi.nih.gov/pub/archive_dtd/publishing/3.0/journal-publishing-dtd-3.0.zip

downloads/nlm-style-5.0.tar.gz: | downloads
	wget -c -P downloads http://www.ncbi.nlm.nih.gov/pmc/assets/nlm-style-5.0.tar.gz

downloads/CrossRef_Schematron_Rules.zip: | downloads
	wget -c -P downloads http://www.crossref.org/schematron/CrossRef_Schematron_Rules.zip

downloads/CrossRef_Schematron_Rules: | downloads/CrossRef_Schematron_Rules.zip
	unzip downloads/CrossRef_Schematron_Rules.zip -d downloads
	touch downloads/CrossRef_Schematron_Rules

downloads/mathml3-dtd.zip: | downloads
	wget -c -P downloads http://www.w3.org/Math/DTD/mathml3-dtd.zip

downloads/mathml3-xsd.zip: | downloads
	wget -c -P downloads http://www.w3.org/Math/XMLSchema/mathml3-xsd.zip

# JATS DTD

jats: | jats/publishing/1.0

# "test" = version of the DTD with no xml:base
jats/publishing/1.0: | downloads/jats-publishing-dtd-1.0.zip
	mkdir -p jats/publishing/1.0
	unzip downloads/jats-publishing-dtd-1.0.zip -d jats/publishing/1.0

# CrossRef Schema

crossref: | crossref/schematron.xsl
	mkdir -p crossref
	wget -c -P crossref http://doi.crossref.org/schemas/crossref4.3.2.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/common4.3.2.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/crossref4.3.1.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/common4.3.1.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/fundref.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/AccessIndicators.xsd

crossref/schematron.xsl: | downloads/CrossRef_Schematron_Rules
	mkdir -p crossref
	xsltproc -output crossref/schematron.xsl downloads/CrossRef_Schematron_Rules/iso_svrl.xsl downloads/CrossRef_Schematron_Rules/deposit.sch

# DataCite schema

datacite: | datacite/meta/kernel-2.2 datacite/meta/kernel-3

datacite/meta/kernel-2.2:
	mkdir -p datacite/meta/kernel-2.2/include
	wget -c -P datacite/meta/kernel-2.2  http://schema.datacite.org/meta/kernel-2.2/metadata.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-titleType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-contributorType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-dateType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-resourceType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relationType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relatedIdentifierType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-descriptionType-v2.xsd

datacite/meta/kernel-3: w3
	mkdir -p datacite/meta/kernel-3/include
	wget -c -P datacite/meta/kernel-3  http://schema.datacite.org/meta/kernel-3/metadata.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-titleType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-contributorType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-dateType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-resourceType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relationType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relatedIdentifierType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-descriptionType-v3.xsd

# W3 DTDs and Schema

w3: | w3/Math/DTD/mathml3 w3/Math/XMLSchema/mathml3
	mkdir -p w3/2009/01
	wget -c -P w3/2009/01 http://www.w3.org/2009/01/xml.xsd

w3/Math/DTD/mathml3: | downloads/mathml3-dtd.zip
	mkdir -p w3/Math/DTD
	unzip downloads/mathml3-dtd.zip -d w3/Math/DTD

w3/Math/XMLSchema/mathml3: | downloads/mathml3-xsd.zip
	mkdir -p w3/Math/XMLSchema
	unzip downloads/mathml3-xsd.zip -d w3/Math/XMLSchema

# DOAJ schema
# http://www.doaj.org/doaj?func=loadTempl&templ=uploadInfo

doaj:
	mkdir -p doaj
	wget -c -P doaj http://www.doaj.org/schemas/doajArticles.xsd

	mkdir -p doaj/appinfo/1
	wget -c -P doaj/appinfo/1  http://www.doaj.org/schemas/appinfo/1/appinfo.xsd

	mkdir -p doaj/iso_639-2b/1.0
	wget -c -P doaj/iso_639-2b/1.0 http://www.doaj.org/schemas/iso_639-2b/1.0/iso_639-2b.xsd

# NLM PMC Style Checker

nlm-stylechecker: | downloads/nlm-style-5.0.tar.gz
	mkdir -p nlm-stylechecker
	tar xvz -C nlm-stylechecker -f downloads/nlm-style-5.0.tar.gz

# eUtils DTDs
# http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/index.shtml

eutils:
	mkdir -p eutils/corehtml/query/DTD
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/pubmed_100101.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/nlmmedlinecitationset_100101.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eLink_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eInfo_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/ePost_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSearch_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSummary_041029.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/egquery.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSpell.dtd

# NLM DTDs
# http://www.ncbi.nlm.nih.gov/data_specs/dtd/

nlm: | nlm/publishing/3.0/journalpublishing3.dtd
	mkdir -p nlm/ncbi/pmc/articleset
	wget -c -P nlm/ncbi/pmc/articleset http://dtd.nlm.nih.gov/ncbi/pmc/articleset/nlm-articleset-2.0.dtd

# NLM Journal Publishing  DTD

nlm/publishing/3.0/journalpublishing3.dtd: | downloads/journal-publishing-dtd-3.0.zip
	mkdir -p nlm/publishing
	unzip downloads/journal-publishing-dtd-3.0.zip -d nlm/publishing
	mv nlm/publishing/publishing nlm/publishing/3.0
	# TODO: remove xml:base from catalog