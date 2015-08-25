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
class Encrypt < Util
  require 'openssl'
  require 'base64'

  def encrypt_envelope(public_key, file_name, id_domain, user, passwd)
    puts file_name
    plain_data = File.open(file_name)
    #if !self.plain_data.blank?
      rsa = OpenSSL::PKey::RSA.new(File.read(public_key))
      puts plain_data
      encrypted = rsa.private_encrypt(plain_data)
      open "c:\private-encrypted.txt", "w" do |io| io.write Base64.encode64(encrypted) end
    #end
  end
  
  def encrypt(result_file, file_name, id_domain, user, passwd)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv
    puts key
    puts iv
    File.open('C:\Users\Daryn\Documents\keyfile', "w+") {|f| f.write(key) }
    File.open('C:\Users\Daryn\Documents\IVfile', "w+") {|f| f.write(iv) }
    buf = ""
    File.open(result_file, "wb") do |outf|
      File.open(file_name, "rb") do |inf|
        while inf.read(4096, buf)
          outf << cipher.update(buf)
        end
        outf << cipher.final
      end
    end
  end
  
 def decrypt(result_file, encrypt_file, id_domain, user, passwd)
   cipher = OpenSSL::Cipher.new('aes-256-cbc')
   cipher.decrypt
   cipher.key = File.read('C:\Users\Daryn\Documents\keyfile')
   cipher.iv = File.read('C:\Users\Daryn\Documents\IVfile')
   #puts cipher.key
   #puts cipher.iv
   buf = ""
   File.open(result_file, "wb") do |outf|
     File.open(encrypt_file, "rb") do |inf|
       while inf.read(4096, buf)
         outf << cipher.update(buf)
       end
       outf << cipher.final
     end
   end
 end
end
      