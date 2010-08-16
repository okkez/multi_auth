class NameLoginForm < ActiveForm
  column :name,     :type => :text
  column :password, :type => :text

  N_("NameLoginForm|Name")
  N_("NameLoginForm|Password")

  validates_presence_of :name
  validates_presence_of :password

  def authenticate
    NameCredential.authenticate(self.name, self.password)
  end
end
