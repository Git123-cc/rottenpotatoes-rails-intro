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
    @all_ratings = Movie.ratings
    if params[:sort]
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
    end
      
    if params[:ratings]
      @t_param = params[:ratings]
    elsif session[:ratings]
      @t_param = session[:ratings]
    end
    
    if params[:sort].nil? and !(session[:sort].nil?) or (params[:ratings].nil? and !(session[:ratings].nil?)) 
      redirect_to movies_path(:sort => @sort, :ratings => @t_param)
    end
    
    if session[:ratings]
      @chosen = session[:ratings].keys
    else
      @chosen = @all_ratings
    end
    @movies = Movie.order(@sort).where(rating: @chosen)
    session[:sort] = @sort
    session[:ratings] = @t_param
    # if (params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
    #   flash.keep
    #   redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
    # end
    # if params[:sort]
    #   @sort = params[:sort]
    # end
    #@movies = Movie.order(@sort)
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
