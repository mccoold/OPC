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
  require 'OPC/Iaas/objectstorage'
  require 'OPC/Iaas/computebase'
  require 'OPC/Iaas/instance'
  require 'OPC/Iaas/seclist'
  require 'OPC/Iaas/blockstorage'
  require 'OPC/Iaas/secrule'
  require 'OPC/Iaas/secapplication'
end
