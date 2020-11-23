
#!/bin/bash

# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


UPSTREAM=$1
DOWNSTREAM=$2

WORK_DIR=/tmp/work
rm -rf $WORK_DIR
git config --global user.email "bot@keyporttech.com";
git config --global user.name "keyporttech-bot";
git clone $UPSTREAM $WORK_DIR;

cd $WORK_DIR && git remote add downstream ${DOWNSTREAM}
cd $WORK_DIR && git config --global user.email "bot@keyporttech.com"
cd $WORK_DIR && git config --global user.name "keyporttech-bot"
cd $WORK_DIR && git fetch downstream master
cd $WORK_DIR && git fetch origin
cd $WORK_DIR && git push -u origin downstream/master:master --force-with-lease
