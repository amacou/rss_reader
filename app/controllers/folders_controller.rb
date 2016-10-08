class FoldersController < ApplicationController
  layout 'setting'
  before_action :authenticate
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  def index
    @folders = current_user.folders.all
  end

  def new
    @folder = Folder.new
  end

  def edit
  end

  def create
    @folder = Folder.new(folder_params)
    @folder.user = current_user
    respond_to do |format|
      if @folder.save
        format.html { redirect_to folders_path, notice: 'Folder was successfully created.' }
        format.json { render action: 'index', status: :created, location: @folder }
      else
        format.html { render action: 'new' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to folders_path, notice: 'Folder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url }
      format.json { head :no_content }
    end
  end

  private
  def set_folder
    @folder = Folder.where(id:params[:id], user_id: current_user.id).first
  end

  def folder_params
    params.require(:folder).permit(:name)
  end
end
