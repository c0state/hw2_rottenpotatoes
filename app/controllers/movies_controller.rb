class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_all_ratings
    all_ratings = []
    Movie.all(:select  => 'distinct(rating)', :order => 'rating').each { |elem|
      all_ratings << elem.rating 
    }
    all_ratings
  end
  
  def get_checked_ratings
    return params[:ratings].keys if params[:ratings]
    return params[:checked_ratings] if params[:checked_ratings]
    return get_all_ratings
  end

  def index
    @all_ratings = get_all_ratings
    @checked_ratings = get_checked_ratings
    @sort_by = params[:sort_by]

    @movies = Movie.find(:all, :conditions => ['rating in (?)', @checked_ratings], :order => @sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
