class ApplicationPlatform < PlatformAgent
  def ios?
    match? /iPhone|iPad/
  end

  def android?
    match? /Android/
  end

  def mac?
    match? /Macintosh/
  end

  def chrome?
    user_agent.browser.match? /Chrome/
  end

  def safari?
    user_agent.browser.match? /Safari/
  end

  def mobile?
    ios? || android?
  end

  def desktop?
    !mobile?
  end
end
