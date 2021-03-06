class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#    raise session.inspect
    @all_ratings = Movie.get_ratings

    if !params[:ratings] && session[:ratings]
      redirect_to(movies_path({:ratings => session[:ratings], :sort => params[:sort]}))
    elsif !params[:sort] && session[:sort]
      redirect_to(movies_path({:ratings => params[:ratings], :sort => session[:sort]}))
    else   
      @checked_ratings = params[:ratings]
      session[:ratings] = @checked_ratings
      session[:sort] = params[:sort]
      if @checked_ratings
        @movies = Movie.where(:rating => @checked_ratings.keys)
      else
        @movies = Movie.all
      end
    end
      
    if params[:sort] == "title"
      @movies = @movies.sort_by {|m| m.title}
    elsif params[:sort] == "date"
      @movies = @movies.sort_by {|m| m.release_date}
    end
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
