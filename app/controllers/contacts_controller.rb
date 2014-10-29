class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :destroy]

  def index
    @contacts = Contact.where(user_id: current_user.id)
    respond_to do |format|
      format.html
      format.csv do
        FileOperation.create_and_enqueue(ContactsExportJob, current_user, {ids: @contacts.pluck(:id)})
        redirect_to file_operations_url, notice: "Contacts export is schedule!"
      end
    end
  end

  def import
    if params[:file]
      FileOperation.create_and_enqueue(ContactsImportJob, current_user, params)
      redirect_to root_url, notice: "Contacts imported is schedule!"
    end
  end

  def remove_dub
    Resque.enqueue(RemoveDublicationJob, current_user.id)
    redirect_to root_url, notice: "Removing dublications is schedule!"
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :number)
    end
end
