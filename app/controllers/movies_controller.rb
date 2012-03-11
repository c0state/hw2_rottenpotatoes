class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_all_ratings
    all_ratings = {}
    Movie.all(:select  => 'distinct(rating)', :order => 'rating').each { |elem|
      all_ratings[elem.rating] = 1
    }
    all_ratings
  end
  
  def get_checked_ratings
    return params[:ratings] if params[:ratings]
    return get_all_ratings
  end

  def save_params_in_session
    session[:sort_by] = params[:sort_by] if params[:sort_by]
    session[:ratings] = params[:ratings] if params[:ratings]
  end
  
  def restore_params_from_session
    restored = false
    params[:ratings] = session[:ratings] and (restored = true) if session[:ratings] and !params[:ratings]
    params[:sort_by] = session[:sort_by] and (restored = true) if session[:sort_by] and !params[:sort_by]
    restored
  end

  def index
    @all_ratings = get_all_ratings
    @ratings = get_checked_ratings
    @sort_by = params[:sort_by]

    save_params_in_session
    if restore_params_from_session
      redirect_to params
    end

    @movies = Movie.find(:all, :conditions => ['rating in (?)', @ratings.keys], :order => @sort_by)
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
