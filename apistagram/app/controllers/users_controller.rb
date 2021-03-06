class UsersController < ApplicationController

  before_filter :find_user, :only => :destroy
  before_filter :find_user_or_username, :except => [:destroy, :contact, :advertize, :report, :legal]
  before_filter :set_title, :except => :legal

  def show
    username = @user.class.to_s == 'User' ? @user.name : @user
    if ["likes", "commented"].include?(params[:sort]) and @user.class.to_s == 'User'
      if params[:sort] == "likes"
        @iphotos = @user.favorite_photos.by_partner_id(partner.id).paginate(:page => params[:page], :per_page => 8)
      else
        @iphotos = @user.commented_photos.by_partner_id(partner.id).paginate(:page => params[:page], :per_page => 8)
      end
    else
      @iphotos = Iphoto.by_partner_id(partner.id).listed.by_username(username).paginate(:page => params[:page], :per_page => 8)
    end
  end

  # payal says: commented the other actions as currently only view profile action is required.
  # def index
  #   @users = User.all
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(params[:id])

  #   if @user.update_attributes(params[:user])
  #     redirect_to @user, notice: 'User was successfully updated.'
  #   else
  #     render action: "edit"
  #   end
  # end

  def remove_all_photos
    if current_user and current_user.is_admin? || current_user == @user
      username = @user.class.to_s == 'User' ? @user.name : @user
      @iphotos = Iphoto.by_partner_id(partner.id).where("username = ?", username)
      @iphotos.update_all({:status => false})
      redirect_to user_url(@user), :notice => "All the photos are deleted."
    else
      redirect_to users_url, :notice => "UnAuthorized Access!!!"
    end
  end

  def destroy
    if current_user and current_user.is_admin? || current_user == @user
      @user.destroy
      redirect_to iphotos_path, :notice => "Your account is deleted successfully! We are sorry to see you go :("
    else
      redirect_to iphotos_path, :notice => "UnAuthorized Access!!!"
    end
  end

  def advertize
    unless request.post?
      render :template => 'users/advertize.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email', 'company'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.contact(@contact, 'Advertisement').deliver
          flash[:notice] = "Details sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end

  def contact
    unless request.post?
      render :template => 'users/contact.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.contact(@contact, 'Contact').deliver
          flash[:notice] = "Contact sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end 

   
  def report
    unless request.post?
      @purl = params[:purl]
      @purl ||= ""
      render :template => 'users/report.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email', 'photo_url'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.contact(@contact, 'Contact').deliver
          flash[:notice] = "Report sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end 

  def legal;end

  private
    def find_user_or_username
      @user = User.where("id = ? or name = ?", params[:id], params[:id]).first
      unless @user
        @user = params[:id]
      end

      redirect_to iphotos_url unless @user      
    end

    def find_user
      @user = User.where("id = ? or name = ?", params[:id], params[:id]).first
      redirect_to iphotos_url unless @user      
    end  

    def set_title
      username = @user.class.to_s == 'User' ? @user.name : @user
      @title = "#{Thread.current[:site_configuration]['app_name'].titleize} - #{username}'s' photos ::#{Thread.current[:site_configuration]['app_name']}::"
    end  
end
