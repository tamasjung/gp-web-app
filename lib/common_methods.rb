module CommonMethods
  def current_pref
    Preference.find_mine current_user
  end
end