class SettingsController < ApplicationController
  def show
  end

  def update
    respond_to do |format|
      if current_user.update(setting_params)
        format.html { redirect_to :setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :setting, notice: "Setting was failed updated." }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def setting_params
    params.require(:user).permit(:sort_type)
  end
end
