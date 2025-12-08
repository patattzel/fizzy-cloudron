module SignupToggle
  def self.flag_path
    ENV.fetch("SIGNUPS_FLAG_PATH", "/app/data/allow_signups")
  end

  def self.allowed?
    boolean = ActiveModel::Type::Boolean.new

    if File.exist?(flag_path)
      raw = File.read(flag_path).strip
      return boolean.cast(raw.presence || true)
    end

    boolean.cast(ENV.fetch("ALLOW_SIGNUPS", "true"))
  end
end
