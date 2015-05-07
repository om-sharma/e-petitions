class SponsorsController < ApplicationController
  before_action :retrieve_petition
  before_action :retrieve_sponsor

  respond_to :html

  def show
    @signature = @sponsor.build_signature(:country => "United Kingdom")
  end

  def update
    @signature = @sponsor.create_signature(signature_params_for_create)

    if @signature.persisted?
      # If the user has filled in all the correc things then we can
      # go straight to validated without the email: the sponsor email
      # that gets them here acts as a validation of their email address
      @signature.perishable_token = nil
      @signature.state = Signature::VALIDATED_STATE
      @signature.save(:validate => false)
      redirect_to thank_you_petition_sponsor_path(@petition, token: @sponsor.perishable_token, secure: true)
    else
      render :show
    end
  end

  def thank_you
  end

  private
  def retrieve_petition
    # TODO: scope the petitions we look at?
    @petition = Petition.find(params[:petition_id])
  end

  def retrieve_sponsor
    @sponsor = @petition.sponsors.find_by!(perishable_token: params[:token])
  end

  def signature_params_for_create
    params.
      require(:signature).
      permit(:name, :address, :town,
             :postcode, :country, :uk_citizenship,
             :terms_and_conditions, :notify_by_email)
  end
end
