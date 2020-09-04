module ApplicationHelper
  def avatar_url(user)
    if user.image
      "https://graph.facebook.com/#{user.uid}/picture?type=large"
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    end
  end
  
  def stripe_express_path
  # ----- TEST -----
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://connect.stripe.com/connect/default/oauth/test&client_id=ca_HmZdg9VWvpwEchu1nuuzlCBFWTzegwfV&state={STATE_VALUE}"
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state={STATE_VALUE}"
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:3000/auth/stripe_connect/callback&client_id=ca_Bz12s2Z5ijkGknATCnWx9EmDZIvGMf0e&state=read_write"

  # ---- LIVE ----
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://parkvillain.com/auth/stripe_connect/callback&client_id=ca_HmZd2YZ3PVyTCB7UBoBfh0fq4lyNNJtp&state={STATE_VALUE}"
  "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://parkvillain.com/auth/stripe_connect/callback&client_id={CONNECTED_STRIPE_ACCOUNT_ID}&state={STATE_VALUE}"
  # "https://dashboard.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_HmZd2YZ3PVyTCB7UBoBfh0fq4lyNNJtp&scope=read_write"
  # "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://parkvillain.com/auth/stripe_connect/callback&client_id=ca_Bz129rceytBvxCIxgLptuWQeV6JayofE&state=read_write"
  end
end