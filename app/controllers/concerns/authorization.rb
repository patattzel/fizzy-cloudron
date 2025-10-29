module Authorization
  private
    def ensure_admin
      head :forbidden unless Current.user.admin?
    end

    def ensure_staff
      head :forbidden unless Current.user.staff?
    end
end
