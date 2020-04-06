defmodule Login.Encryption do
  require Bcrypt

  def encrypt_password(password) do
    salt = Bcrypt.gen_salt(12, true)
    encrypted_password = Bcrypt.Base.hash_password(password, salt)
    encrypted_password
  end

  def check_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end
end
