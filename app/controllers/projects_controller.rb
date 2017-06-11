class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, :set_rewards, only: [:edit, :new, :show, :rewards]
  before_action :current_user
  before_action :is_project_owner?, only: [:edit, :update, :destroy]
  before_action :set_current_amount, only: [:show]


  def index
    @projects = Project.search(params[:search])
    if params[:search]
      if (@projects.nil?||@projects.length==0) && params[:search]
        redirect_to root_path, notice: "Match not found"
      elsif @projects.length>0 && params[:search].to_i==0
        redirect_to @projects[0]
      end
    end
    #raise
  end

  def show
    @pledge = Pledge.new
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = @current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        (Follow.where(following_id: @current_user.id)).each do |query_result|
          to_user = User.find(query_result.follower_id)
          ProjectMailer.new_project_email(to_user, current_user).deliver_later
        end
        format.html { redirect_to edit_project_path(@project) , notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def set_current_amount
      @current_amount = Pledge.where(project_id:params[:id]).sum(:amount)
    end

    def set_rewards
      @rewards = Reward.search(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :category_id, :user_id, :start_date, :end_date, :goal)
    end
end
