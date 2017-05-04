# == Defined resource type: ipmi::ciphers
#
# the ciphers list refers to the ciphers that are useable by admin
# ipmitool lan print will list which are available, but all 14 
# should be represented in the ciphers_list string - they should be marked
# 'X' to show they are excluded
#
# RMCP+ Cipher Suites : 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
#
# the below command will display the various ciphers:
#
# ipmitool channel getciphers ipmi 1
# ID   IANA    Auth Alg        Integrity Alg   Confidentiality Alg
# 0    N/A     none            none            none
# 1    N/A     hmac_sha1       none            none
# 2    N/A     hmac_sha1       hmac_sha1_96    none
# 3    N/A     hmac_sha1       hmac_sha1_96    aes_cbc_128
# 4    N/A     hmac_sha1       hmac_sha1_96    xrc4_128
# 5    N/A     hmac_sha1       hmac_sha1_96    xrc4_40
# 6    N/A     hmac_md5        none            none
# 7    N/A     hmac_md5        hmac_md5_128    none
# 8    N/A     hmac_md5        hmac_md5_128    aes_cbc_128
# 9    N/A     hmac_md5        hmac_md5_128    xrc4_128
# 10   N/A     hmac_md5        hmac_md5_128    xrc4_40
# 11   N/A     hmac_md5        md5_128         none
# 12   N/A     hmac_md5        md5_128         aes_cbc_128
# 13   N/A     hmac_md5        md5_128         xrc4_128
# 14   N/A     hmac_md5        md5_128         xrc4_40
# 
# the default is to allow only those required by SOL or any 128/aes128
# 
# Note: this is not required for HP

define ipmi::ciphers (
  $ciphers_list = 'XXXaXXXXaXXXaXX',
){
  require ::ipmi

  validate_string($ciphers_list)

  exec { "ipmi_set_ciphers":
    command => "/usr/bin/ipmitool lan set 1 cipher_privs ${ciphers_list}",
    onlyif  => "/usr/bin/test \"$(ipmitool lan print | grep 'Cipher Suite Priv Max' | sed -e 's/.* : //g')\" != \"${ciphers_list}\"",
  }
}
