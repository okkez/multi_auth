# -*- coding: utf-8 -*-
module OpenIdAuthentication
  class Result
    ERROR_MESSAGES.update({
      :missing      => p_("OpenIdAuthentication", "Sorry, the OpenID server couldn't be found"),
      :invalid      => p_("OpenIdAuthentication", "Sorry, but this does not appear to be a valid OpenID"),
      :canceled     => p_("OpenIdAuthentication", "OpenID verification was canceled"),
      :failed       => p_("OpenIdAuthentication", "OpenID verification failed"),
      :setup_needed => p_("OpenIdAuthentication", "OpenID verification needs setup"),
    })
  end
end
