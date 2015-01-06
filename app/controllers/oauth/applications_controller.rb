class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_filter :authenticate_developer!

  def index
    @applications = current_developer.oauth_applications
  end

  # only needed if each application must have some owner
  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = current_developer if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      respond_with( :oauth, @application, location: oauth_application_url( @application ) )
    else
      render :new
    end
  end
end
