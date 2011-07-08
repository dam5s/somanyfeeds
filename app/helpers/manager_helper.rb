module ManagerHelper

  def git_msg c
    c['commit']['message']
  end

  def git_author c
    c['author']['login']
  end

  def git_avatar c
    c['author']['avatar_url']
  end

end
