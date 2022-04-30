#!/usr/bin/env bash

echo '### install software'
sudo apt install -y build-essential
sudo apt install -y curl
sudo apt install -y dkms
sudo apt install -y geany
sudo apt install -y git
sudo apt install -y libexpat1-dev
sudo apt install -y libgdbm-dev
sudo apt install -y libicu-dev
sudo apt install -y libssl-dev
sudo apt install -y libwrap0-dev
sudo apt install -y libxml2-dev
sudo apt install -y libxml2-utils
sudo apt install -y libxslt1-dev
sudo apt install -y libyaz-dev
sudo apt install -y nano
sudo apt install -y pkg-config 
sudo apt install -y perl-doc
sudo apt install -y cpanminus
sudo apt install -y sqlite3
sudo apt install -y tilix
sudo apt install -y virtualbox-guest-utils
sudo apt install -y virtualbox-guest-x11
sudo apt install -y wget
sudo apt install -y xfce4-xkb-plugin
sudo apt install -y xsltproc
sudo apt install -y zlib1g
sudo apt install -y zlib1g-dev

echo '### upgrade ###'
sudo apt upgrade -y

echo '### install local Perl environment ###'
# install perlbrew
curl -L https://install.perlbrew.pl | bash
# edit .bashrc
echo -e '\nsource ~/perl5/perlbrew/etc/bashrc\n' >> ~/.bashrc
source ~/perl5/perlbrew/etc/bashrc
# initialize
perlbrew init
# install a Perl version
perlbrew install -j 2 -n perl-5.34.1
# switch to an installation and set it as default
perlbrew switch perl-5.34.1
# install cpanm
perlbrew install-cpanm

echo '### install Perl modules ###'
# manual install of patched Net-Z3950-ZOOM
cpanm ExtUtils::PkgConfig
wget https://cpan.metacpan.org/authors/id/M/MI/MIRK/Net-Z3950-ZOOM-1.30.tar.gz
tar zxvf Net-Z3950-ZOOM-1.30.tar.gz
cd Net-Z3950-ZOOM-1.30
wget https://salsa.debian.org/perl-team/modules/packages/libnet-z3950-zoom-perl/raw/master/debian/patches/pkg-config.patch
patch Makefile.PL < pkg-config.patch
cpanm .
cd ..
rm Net-Z3950-ZOOM-1.30.tar.gz
rm -rf Net-Z3950-ZOOM-1.30
# install cpm
cpanm App::cpm
# install modules
cpm install -g Catmandu Catmandu::AlephX Catmandu::BibTeX Catmandu::Breaker Catmandu::Cmd::repl Catmandu::Exporter::Table Catmandu::Exporter::Template Catmandu::Fix::cmd Catmandu::Fix::Date Catmandu::Fix::XML Catmandu::Identifier Catmandu::Importer::MODS Catmandu::LIDO Catmandu::MAB2 Catmandu::MARC Catmandu::MODS Catmandu::OAI Catmandu::OCLC Catmandu::PICA Catmandu::PNX Catmandu::RDF Catmandu::SRU Catmandu::Stat Catmandu::Template Catmandu::Validator::JSONSchema Catmandu::Wikidata Catmandu::XLS Catmandu::XML Catmandu::XSD Catmandu::Z3950 MARC::Record::Stats MARC::Schema

echo '### enable copy&paste between guest and host ###'
sudo apt install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)

echo '### cleanup ... ### '
sudo rm -rf /root/.cache
sudo rm -rf /home/elag/.perl-cpm
sudo rm -rf /home/elag/.cache
sudo apt autoremove
sudo apt clean
sudo apt autoclean
history -cw

echo '### reboot ###'
sudo reboot
