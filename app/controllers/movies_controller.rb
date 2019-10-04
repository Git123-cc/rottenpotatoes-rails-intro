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
    
    if params[:is_sorted]
      @is_sorted = params[:is_sorted]
    else 
      @is_sorted = false
    end
    
    if params[:ratings]
      @t_param = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @t_param = session[:ratings]
    else
      @all_ratings.each do |r|
        (@t_param ||= { })[r] = 1
      end
    end
    
    if params[:sort].nil? and !(session[:sort].nil?) or (params[:ratings].nil? and !(session[:ratings].nil?)) 
      redirect_to movies_path(:sort => @sort, :ratings => @t_param)
    end
    
    @chosen = @t_param.keys #@all_ratings
    @movies = Movie.where(rating: @chosen)
    puts session[:prevsort]
    puts @sort
    puts @is_sorted
    if((@is_sorted == "false" && session[:prevsort] == @sort) || (session[:prevsort] != @sort))
      @movies = @movies.order(@sort)
      @is_sorted = "true"
    elsif session[:prevsort] == @sort 
      @is_sorted = "false"
    end
    session[:prevsort] = session[:sort]
    session[:sort] = @sort
    session[:ratings] = @t_param

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
