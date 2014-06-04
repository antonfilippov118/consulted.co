class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new contact_params
    if @contact.send!
      redirect_to success_contact_path
    else
      render :new
    end
  end

  def success

  end

  def find_expert
    result = FindsTheRightExpert.for find_params
    if result.success?
      render json: { success: true }
    else
      render json: { error: result.message }
    end
  end

  private

  def contact_params
    params.require(:contact).permit :message, :email, :subject, :name
  end

  def find_params
    slug = params.require(:offer).permit(:slug).fetch :slug
    { offer: slug }.merge user: @user
  end
end
