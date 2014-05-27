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

  private

  def contact_params
    params.require(:contact).permit :message, :email, :subject, :name
  end
end
