class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    # sort by title or release date
    @sort = params[:sort]
    if @sort == 'title'
      @title_header = 'hilite'
    elsif @sort == 'release_date'
      @release_date_header = 'hilite'
    end
    # set up sessions
    if session[:ratings].nil?
      session[:ratings] = @all_ratings
    elsif session[:sort].nil?
      session[:sort]= @sort
    end
    # remember the settings
    if params[:ratings]
      session[:ratings] = params[:ratings].keys
    elsif params[:sort]
      session[:sort] = params[:sort]
    # RESTful
    elsif params[:ratings].nil? or params[:sort].nil?
      flash.keep
      redirect_to movies_path(:ratings => Hash[session[:ratings].map {|x| [x, 1]}], :sort => @sort)
    end 
    @ratings = session[:ratings]
    @sort = session[:sort]
    # sort and filter
    @movies = Movie.order(@sort).where(rating: @ratings)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end 
