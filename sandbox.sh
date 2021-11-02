#!/bin/bash

# ============================================
# Configure sandbox for quick workspace setup.
# ============================================

echo '== Install libgmp3 =='
sudo apt-get install libgmp3-dev -y

echo '== Install mysql client =='
sudo apt-get install mysql-client libmysqlclient-dev -y

echo '== Update system =='
sudo apt-get update

echo '== Install latest rails =='
gem install rails

echo '== Bundle install =='
bundle install
