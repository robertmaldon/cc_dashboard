class StylesheetsController < ApplicationController

  def show
    respond_to do |format|
      format.css do
        render :action => params[:id]
      end
    end
  end

  def skin
    respond_to do |format|
      format.css do
        #render :action => params[:id]
        render :template => "stylesheets/skins/#{params[:id]}"
      end
    end
  end

end
