class Accounts::JoinCodesController < ApplicationController
  def show
    render svg: RQRCode::QRCode.new(join_url(Current.account.join_code)).as_svg(viewbox: true, fill: :white, color: :black)
  end

  def update
    Current.account.reset_join_code
    redirect_to account_users_path
  end
end
