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

  def main_menu_link(label, path)
    if request.path == path
      haml_tag :a, label, {class: 'current'}
    else
      haml_tag :a, label, {href: path}
    end
  end
end
