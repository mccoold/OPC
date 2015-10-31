# Author:: Daryn McCool (<mdaryn@hotmail.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class Iaas < OPC
  require 'opc/iaas/objectstorage'
  require 'opc/iaas/computebase'
  require 'opc/iaas/instance'
  require 'opc/iaas/seclist'
  require 'opc/iaas/secassoc'
  require 'opc/iaas/iputil'
  require 'opc/iaas/orchestration'
  require 'opc/iaas/launchplan'
  require 'opc/iaas/seciplist'
  require 'opc/iaas/blockstorage'
  require 'opc/iaas/secrule'
  require 'opc/iaas/secapplication'
end