Augury.vent.on 'connection:select', (signup, storeId) ->
  window.location.href = "/admin/integration/register?url=#{Augury.url}&env=#{signup.env}&user=#{signup.user}&user_token=#{signup.auth_token}&store_id=#{storeId}"
