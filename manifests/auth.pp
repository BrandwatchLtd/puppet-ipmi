# == Defined resource type: ipmi::auth
# title should be one of: Callback, User, Operator, Admin
# the preferred auth type available atm is MD5, marginally better than MD2 or plain

define ipmi::auth (
  $auth_type = 'MD5',
){
  require ::ipmi

  validate_re($title, '^Callback$|^User$|^Operator$|^Admin$', 'Auth title should be one of: Callback|User|Operator|Admin')
  validate_re($auth_type, '^NONE$|^MD2$|^MD5$|^PASSWORD$', 'Auth type should be one of: NONE|MD2|MD5|PASSWORD')

  exec { "ipmi_set_auth_${title}":
    command => "/usr/bin/ipmitool lan set 1 auth ${title} ${auth_type}",
    onlyif  => "/usr/bin/test \"$(ipmitool lan print | grep -A 4 'Auth Type Enable' | grep \"${title}\" | sed -e 's/.* : //g' -e 's/[[:space:]]*$//')\" != \"${auth_type}\"",
  }
}
