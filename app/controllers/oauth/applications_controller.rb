class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  respond_to :html
  before_filter :authenticate_user!

  def index
    @applications = current_user.oauth_applications
  end

  # only needed if each application must have some owner
  def create
    @application = Doorkeeper::Application.new(application_params)

    if Doorkeeper.configuration.confirm_application_owner?
      @application.owner = current_user
    end

    if @application.save
      flash[:notice] =
        I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])

      respond_with(:oauth,
                   @application,
                   location: oauth_application_url(@application))
    else
      render :new
    end
  end
end
