module ManagerHelper

  def git_msg c
    c['commit']['message'] rescue ""
  end

  def git_author c
    c['author']['login'] rescue ""
  end

  def git_avatar c
    c['author']['avatar_url'] rescue ""
  end

end
