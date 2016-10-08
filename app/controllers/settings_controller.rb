class SettingsController < ApplicationController
  def show
  end

  def update
    if current_user.update(setting_params)
       redirect_to :setting, notice: 'Setting was successfully updated.'
    else
      redirect_to :setting, notice: "Setting was failed updated."
    end
  end

  private
  def setting_params
    params.require(:user).permit(:sort_type)
  end
end
