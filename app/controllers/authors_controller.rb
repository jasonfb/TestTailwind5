class AuthorsController < ApplicationController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_author, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }
 
  def load_author
    @author = (Author.find(params[:id]))
  end
  

  def load_all_authors 
    @authors = ( Author.page(params[:page]))  
  end

  def index
    load_all_authors
  end

  def new 
    @author = Author.new()
   
  end

  def create
    modified_params = modify_date_inputs_on_params(author_params.dup)


    @author = Author.create(modified_params)

    if @author.save
      flash[:notice] = "Successfully created #{@author.name}"
      load_all_authors
      render :create
    else
      flash[:alert] = "Oops, your author could not be created. #{@hawk_alarm}"
      render :create, status: :unprocessable_entity
    end
  end


  def edit
    render :edit
  end

  def update
    modified_params = modify_date_inputs_on_params(author_params)
      

    if @author.update(modified_params)
      
      flash[:notice] = (flash[:notice] || "") << "Saved #{@author.name}"
      flash[:alert] = @hawk_alarm if @hawk_alarm
      render :update
    else
      flash[:alert] = (flash[:alert] || "") << "Author could not be saved. #{@hawk_alarm}"
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @author.destroy
    rescue StandardError => e
      flash[:alert] = "Author could not be deleted."
    end
    load_all_authors
  end

  def author_params
    params.require(:author).permit( [:name] )
  end

  def namespace
    ""
  end
end


