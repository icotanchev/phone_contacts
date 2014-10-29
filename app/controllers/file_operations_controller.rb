class FileOperationsController < ApplicationController
  before_action :set_file_operation, only: [:show, :destroy]

  def index
    @file_operations = FileOperation.where(user_id: current_user.id, job_class: 'ContactsExportJob')
  end

  def show
    @file = FileOperation.find(params[:id])
    file_name = @file.file_path.split('/').last
    logger.debug("~" * 80)
    logger.debug(@file.file_path)
    logger.debug(file_name)
    logger.debug("~" * 80)

    send_file(@file.file_path, :filename => file_name)
  end

  def destroy
    @file_operation.destroy
    respond_to do |format|
      format.html { redirect_to file_operations_url, notice: 'File operation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_operation
      @file_operation = FileOperation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def file_operation_params
      params.require(:file_operation).permit(:file_path, :status, :job_class, :user_type, :user_id, :info)
    end
end
