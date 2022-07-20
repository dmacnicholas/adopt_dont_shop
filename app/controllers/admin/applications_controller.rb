class Admin::ApplicationsController < ApplicationController
   def show
      @application = Application.find(params[:id])
      @pets = @application.pets

      if params.include?(:search)
         @adopted_pets = Pet.search(params[:search])
      end
   end

   def update
		@application = Application.find(params[:id])
		@application.adopt_pets(application_params)

		redirect_to "/admin/applications/#{@application.id}"
	end

	private

	def application_params
		params.permit(:approve, :reject)
	end
end